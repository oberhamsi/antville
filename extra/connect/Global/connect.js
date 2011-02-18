// The Antville Project
// http://code.google.com/p/antville
//
// Copyright 2001-2011 by The Antville People
//
// Licensed under the Apache License, Version 2.0 (the ``License'');
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an ``AS IS'' BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
// $Revision$
// $LastChangedBy$
// $LastChangedDate$
// $URL$

/**
 * @fileoverview Defines the Antville Connect Feature.
 */

// FIXME: Remove ASAP (testing only)
Feature.remove();

// FIXME: Connecting with Twitter and Google currently does not return an e-mail address.
// Instead, noreplay@antville.org is used � which is very poor and should be fixed ASAP.

app.addRepository(app.dir + "/../lib/scribe-1.1.0.jar");

var connect = new Feature("Antville Connect", "http://code.google.com/p/antville/wiki/connect",
      "Connecting Antville with Facebook");

connect.handle("getPermission", function(action) {
   if (action === "connect") {
      return true;
   }
});

Members.prototype.connect_action = function() {
   try {
      switch (req.data.type) {
         case "facebook":
         connect.facebook(req);
         break;
         case "google":
         case "twitter":
         connect.scribe(req.data.type);
         break;
      }
   } catch (ex) {
      session.logout()
      res.message = String(ex);
      res.redirect(res.handlers.members.href("login"));
   }
   res.redirect(User.getLocation() || res.handlers.site.href());
   return;
}

connect.getUserByConnection = function(type, id) {
   var user;
   var connections = root.connections.get(id);
   if (connections) {
      connections.list().some(function(metadata, index) {
         if (metadata.name === type + "_id") {
            user = metadata.parent;
         }
      });
   }
   return user;
}

connect.scribe = function(type) {
   var name = type.titleize();
   var appId = getProperty("connect." + type + ".id");
   var secret = getProperty("connect." + type + ".key");

   if (!secret || req.data.denied) {
      throw Error(gettext("Connecting with {0} failed. {1} Please try again.", name,
            gettext("You denied the request.")));
   }

   if (req.isPost()) {
      try {
         User.login(req.postParams);
      } catch (ex) { }
   }

   var scribe = Packages.org.scribe;
   var provider, requestUrl, scope, getValues;
   var headers = {};

   switch (type) {
      case "google":
      provider = scribe.builder.api.GoogleApi;
      requestUrl = "http://www-opensocial.googleusercontent.com/api/people/@me/@self";
      scope = "http://www-opensocial.googleusercontent.com/api/people/";
      headers["GData-Version"] = "3.0";
      getValues = function(data) {
         data = data.entry;
         return {
            id: data.id,
            name: data.displayName,
            email: data.email,
            url: data.url
         }
      }
      break;

      case "twitter":
      provider = scribe.builder.api.TwitterApi;
      requestUrl = "https://api.twitter.com/1/account/verify_credentials.json";
      getValues = function(data) {
         return {
            id: data.id_str,
            name: data.screen_name,
            email: data.email,
            url: data.profileUrl
         }
      }
      break;
   }

   var service = new scribe.builder.ServiceBuilder()
         .provider(provider)
         .apiKey(appId)
         .apiSecret(secret)
         .callback(path.href(req.action) + "?type=" + type);

   if (scope) {
      service.scope(scope);
   }

   var oauth = service.build();

   var verifier = req.data.oauth_verifier;
   if (!verifier) {
      // Because the service provider will redirect back to this URL the
      // request token needs to be stored in the session object
      session.data.requestToken = oauth.getRequestToken();
      res.redirect(oauth.getAuthorizationUrl(session.data.requestToken));
   }

   try {
      var accessToken = oauth.getAccessToken(session.data.requestToken,
            new scribe.model.Verifier(verifier));
   } catch (ex) {
      throw Error(gettext("Connecting with {0} failed. {1} Please try again.", name,
            gettext("Something went wrong.")));
   }

   var request = new scribe.model.OAuthRequest(scribe.model.Verb.GET, requestUrl);
   oauth.signRequest(accessToken, request);
   for (let name in headers) {
      request.addHeader(name, headers[name]);
   }
   var response = request.send();

   var data = getValues(JSON.parse(response.getBody()));
   var user = connect.getUserByConnection(type, data.id);
   if (!user) {
      if (!session.user) {
         var name = root.users.getAccessName(data.name);
         user = User.register({
            name: name,
            hash: session.data.requestToken.getToken(),
            email: data.email || "noreply@antville.org",
            url: data.url
         });
         session.login(user);
      } else {
         user = session.user;
      }
      user.setMetadata(type + "_id", data.id);
   } else if (user !== session.user) {
      session.login(user);
   }

   return;
}

connect.facebook = function(req) {
   var appId = getProperty("connect.facebook.id");
   var secret = getProperty("connect.facebook.key");
   if (!secret || req.data.error) {
      throw Error(gettext("Could not connect with Facebook. ({0})", -1));
   }

   if (req.isPost()) {
      try {
         User.login(req.postParams);
      } catch (ex) { }
   }

   var url = path.href(req.action) + "?type=facebook";

   var code = req.data.code;
   if (!code) {
      res.redirect("https://www.facebook.com/dialog/oauth?client_id=" + appId +
            "&scope=email&redirect_uri=" + url);
      return;
   }

   var mime = getURL("https://graph.facebook.com/oauth/access_token?client_id=" + appId +
         "&redirect_uri=" + url + "&client_secret=" + secret + "&code=" + code);

   if (!mime || !mime.text) {
      throw Error(gettext("Could not connect with Facebook. ({0})", -3));
   }

   var token = mime.text;
   mime = getURL("https://graph.facebook.com/me?" + token);

   if (!mime || !mime.text) {
      throw Error(gettext("Could not connect with Facebook. ({0})", -4));
   }

   var data = JSON.parse(mime.text);
   var user = connect.getUserByConnection("facebook", data.id);
   if (!user) {
      if (!session.user) {
         var name = root.users.getAccessName(data.name);
         user = User.register({
            name: name,
            hash: token,
            email: data.email,
            url: data.link,
         });
         session.login(user);
      } else {
         user = session.user;
      }
      user.setMetadata("facebook_id", data.id);
   } else if (user !== session.user) {
      session.login(user);
   }

   return;
}

/*connect.twitter = function(req) {
   var appId = "gfxWDsNEM2A7ldPWaA7A";
   var secret = getProperty("connect.twitter.secret");
   if (!secret) {
      res.message = gettext("Could not connect with Twitter. ({0})", -1);
      res.redirect(connect.getLoginUrl());
   }

   if (req.isPost()) {
      try {
         User.login(req.postParams);
      } catch (ex) { }
   }

   var scribe = Packages.org.scribe;
   var oauth = new scribe.builder.ServiceBuilder()
         .provider(scribe.builder.api.TwitterApi)
         .apiKey(appId)
         .apiSecret(secret)
         .callback(path.href(req.action) + "?type=twitter")
         .build();

   var verifier = req.data.oauth_verifier;
   if (!verifier) {
      // As Twitter will redirect back to this URL the request token needs to be stored in the session
      session.data.requestToken = oauth.getRequestToken();
      var token = session.data.requestToken.getToken();
      res.redirect("https://twitter.com/oauth/authorize?oauth_token=" + token);
   }

   var accessToken = oauth.getAccessToken(session.data.requestToken,
         new scribe.model.Verifier(verifier));
   var request = new scribe.model.OAuthRequest(scribe.model.Verb.GET,
         "https://api.twitter.com/1/account/verify_credentials.json");
   oauth.signRequest(accessToken, request);
   var response = request.send();

   var data = JSON.parse(response.getBody());
   var user = connect.getUser("twitter", data.id_str);
   if (!user) {
      if (!session.user) {
         var name = root.users.getAccessName(data.screen_name);
         user = User.register({
            name: name,
            hash: session.data.requestToken.getToken(),
            email: data.email || "noreply@antville.org",
            url: data.url
         });
         session.login(user);
      } else {
         user = session.user;
      }
      user.setMetadata("twitter_id", data.id_str);
   } else if (user !== session.user) {
      session.login(user);
   }

   return true;
}

connect.google = function(req) {
   var appId = "anonymous";
   var secret = getProperty("connect.google.secret");
   if (!secret) {
      res.message = gettext("Could not connect with Google. ({0})", -1);
      res.redirect(connect.getLoginUrl());
   }

   if (req.isPost()) {
      try {
         User.login(req.postParams);
      } catch (ex) { }
   }

   var scribe = Packages.org.scribe;
   var oauth = new scribe.builder.ServiceBuilder()
         .provider(scribe.builder.api.GoogleApi)
         .apiKey(appId)
         .apiSecret(secret)
         .callback(path.href(req.action) + "?type=google")
         .scope("http://www-opensocial.googleusercontent.com/api/people/")
         .build();

   var verifier = req.data.oauth_verifier;
   if (!verifier) {
      // As Google will redirect back to this URL the request token needs to be stored in the session
      session.data.requestToken = oauth.getRequestToken();
      var token = session.data.requestToken.getToken();
      res.redirect("https://www.google.com/accounts/OAuthAuthorizeToken?oauth_token=" + token);
   }

   var accessToken = oauth.getAccessToken(session.data.requestToken,
         new scribe.model.Verifier(verifier));

   var request = new scribe.model.OAuthRequest(scribe.model.Verb.GET,
         "http://www-opensocial.googleusercontent.com/api/people/@me/@self");
   oauth.signRequest(accessToken, request);
   request.addHeader("GData-Version", "3.0");
   var response = request.send();

   var data = JSON.parse(response.getBody()).entry;
   var user = connect.getUser("google", data.id);
   if (!user) {
      if (!session.user) {
         var name = root.users.getAccessName(data.displayName);
         user = User.register({
            name: name,
            hash: session.data.requestToken.getToken(),
            email: data.email || "noreply@antville.org",
            url: data.profileUrl
         });
         session.login(user);
      } else {
         user = session.user;
      }
      user.setMetadata("google_id", data.id);
   } else if (user !== session.user) {
      session.login(user);
   }

   return true;
} */

// FIXME: Maybe useful for future autoLogin via cookie?
/*if (!token) {
   var cookie = req.cookies["fbs_" + appId];
   if (cookie) {
      var parts = cookie.split("&");
      for each (let part in parts) {
         let pair = part.split("=");
         if (pair[0] === "access_token") {
            token = pair[1];
            break;
         }
      }
   }
}*/