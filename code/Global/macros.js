/**
 * macro renders the current timestamp
 */
function now_macro(param) {
   var now = new Date();
   if (path.site)
      res.write(formatTimestamp(now,param.format));
   else if (param.format) {
      var sdf = new java.text.SimpleDateFormat(param.format);
      var result = tryEval("sdf.format(now)");
      if (result.error)
         return ("[error: wrong date-format]");
      return (result.value);
   } else
      res.write(now.format("yyyy.MM.dd HH:mm"));
}


/**
 * macro renders the antville-logos
 */
function logo_macro(param) {
   if (!param.name)
      return;
   var logo = root.images.get(param.name);
   if (!logo)
      return;
   openLink(root.href());
   renderImage(logo, param);
   closeLink();
}


/**
 * macro renders an image out of image-pool
 * either as plain image, thumbnail, popup or url
 * param.name can contain a slash indicating that
 * the image belongs to a different site or to root
 */
function image_macro(param) {
   if (!param.name)
      return;
   var img = getPoolObj(param.name, "images");
   if (!img)
      return;
   var imgObj = img.obj;
   var url = imgObj.getStaticUrl();

   // return different display according to param.as
   if (param.as == "url")
      return(url);
   else if (param.as == "thumbnail") {
      if (!param.linkto)
         param.linkto = url;
      if (imgObj.thumbnail)
         imgObj = imgObj.thumbnail;
   }
   else if (param.as == "popup") {
      param.linkto = imgObj.popupUrl();
      if (imgObj.thumbnail)
         imgObj = imgObj.thumbnail;
   }
   delete(param.name);
   delete(param.as);

   // render image tag
   if (param.linkto) {
      openLink(param.linkto);
      delete(param.linkto);
      renderImage(imgObj, param);
      closeLink();
   }
   else
      renderImage(imgObj, param);
}


/** 
 * DEPRECATED!
 * use image_macro() with param.as = "popup" instead
 */
function thumbnail_macro(param) {
   param.as = "popup";
   image_macro(param);
}


/**
 * DEPRECATED!
 * use image_macro() with param.as = "url" instead
 */
function imageurl_macro(param) {
   param.as = "url";
   image_macro(param);
}


/**
 *  Global link macro. In contrast to the hopobject link macro,
 *  this reproduces the link target without further interpretation.
 */
function link_macro(param) {
   if (param.to)
      param.href = param.to;
   else // backwards compatibility
      param.href = param.linkto;
   if (param.urlparam)
      param.href += "?" + param.urlparam;
   if (param.anchor)
      param.href += "#" + param.anchor;
   var content = param.text ? param.text : param.href;

   delete param.to;
   delete param.linkto;
   delete param.urlparam;
   delete param.anchor;
   delete param.text;

   openMarkupElement("a", param);
   res.write(content);
   closeMarkupElement("a");
}


/**
 * macro fetches a file-object and renders a link to "getfile"-action
 */
function file_macro(param) {
   if (!param.name)
      return;
   var p = getPoolObj(param.name,"files");
   if (!p)
      return;
   p.obj.renderSkin(param.useskin ? param.useskin : "main");
}


/**
 * Macro creates a string representing the objects in the
 * current request path, linked to their main action.
 */
function linkedpath_macro (param) {
   var separator = param.separator;
   if (!separator)
      separator = " &gt; ";
   var title = "Home";
   for (var i=1; i<path.length-1; i++) {
      title = path[i].getNavigationName();
      openLink(path[i].href());
      res.write(title);
      closeLink();
      res.write(separator);
   }
   title = path[path.length-1].getNavigationName();
   res.write(title);
}


/**
 * Renders a poll (optionally as link or results)
 */
function poll_macro(param) {
   var parts = param.id.split("/");
   if (parts.length == 2) {
      var blog = root.get(parts[0]);
      var poll = blog.polls.get(parts[1]);
   }
   else {
      var blog = path.site;
      var poll = blog.polls.get(param.id);
   }
   if (!poll)
      return(getMsg("error","pollNoExist",param.id));
   var deny = poll.isVoteDenied(session.user);
   if (poll.closed || param.as == "results")
      poll.renderSkin("results");
   else if (deny || param.as == "link") {
      openLink(poll.href());
      res.write(poll.question);
      closeLink();
   }
   else {
      res.data.action = poll.href();
      poll.renderSkin("main");
   }
}


/**
 * macro basically renders a list of sites
 * but first it checks which collection to use
 */
function sitelist_macro(param) {
   if (param.show == "all")
      var collection = root.public;
   else
      var collection = root;
   
   var size = collection.size();
   if (!size)
      return;
   
   // setting some general limitations:
   var minDisplay = 10;
   var maxDisplay = 100;
   
   var idx = parseInt (req.data.start,10);
   var max = Math.min((param.limit ? parseInt(param.limit,10) : minDisplay),maxDisplay);
   
   var scroll = (!param.scroll || param.scroll == "no" ? false : true);
   
   if (isNaN(idx) || idx > size-1 || idx < 0)
      idx = 0;
   if (scroll && idx > 0) {
      var sp = new Object();
      sp.url = root.href("list") + "?start=" + Math.max(0, idx-max);
      sp.text = "previous weblogs";
      renderSkinAsString("prevpagelink",sp);
      renderMarkupElement("br");
   }
   var cnt = 0;
   while (cnt < max && idx < size) {
      var w = collection.get(idx++);
      if (!w.isBlocked() && !w.isNotPublic()) {
         w.renderSkin("preview");
         cnt++;
      }
   }
   if (scroll && idx < size) {
      var sp = new Object();
      sp.url = root.href("list") + "?start=" + idx;
      sp.text = "more weblogs";
      renderMarkupElement("br");
      renderSkin("nextpagelink",sp);
   }
}


/**
 * macro checks if the current session is authenticated
 * if true it returns the username
 */
function username_macro(param) {
   if (session.user)
      res.write(session.user.name);
   return;
}


/**
 * function renders a form-input
 */
function input_macro(param) {
   param.value = param.name && req.data[param.name] ? encodeForm(req.data[param.name]) : param.value;
   if (param.type == "textarea")
      return(renderInputTextarea(param));
   else if (param.type == "checkbox")
      return(renderInputCheckbox(param));
   else if (param.type == "button") {
      param.type = "submit";
      return(renderInputButton(param));
   } else if (param.type == "password")
      return(renderInputPassword(param));
   else if (param.type == "file")
      return(renderInputFile(param));
   else
      return(renderInputText(param));
}


/**
 * function renders a shortcut
 */
function shortcut_macro(param) {
   if (param && param.name) {
      var sc = path.site.shortcuts.get(param.name);
      if (sc)
         sc.renderContent(param.text);
      else
         return(param.name);
   }
}


/**
 * function renders a list of stories either contained
 * in a topic or from the story collection.
 * param.sortby determines the sort criteria
 * (title, createtime, modifytime);
 * param.order determines the sort order (asc or desc)
 * param.show determines the text type (story, comment or all)
 */
function storylist_macro(param) {
   if (param.sortby != "title" && param.sortby != "createtime" && param.sortby != "modifytime")
      param.sortby = "modifytime";
   if (param.order != "asc" && param.order != "desc")
      param.order = "asc";

   var order = " order by TEXT_" + param.sortby.toUpperCase() + " " + param.order;

   var rel = "";
   if (param.show == "stories")
      rel += " and TEXT_PROTOTYPE = 'story'";
   else if (param.show == "comments")
      rel += " and TEXT_PROTOTYPE = 'comment'";

   if (param.topic)
      rel += " and TEXT_TOPIC = '" + param.topic + "'";

   var query = "select * from AV_TEXT where TEXT_F_SITE = " + path.site._id + " and TEXT_ISONLINE > 0" + rel + order;

   var connex = getDBConnection("antville");
   var rows = connex.executeRetrieval(query);

   if (rows) {
      var cnt = 0;
      param.limit = param.limit ? Math.min(parseInt(param.limit), 100) : 25;
      while (rows.next() && (cnt < param.limit)) {
         cnt++;
         var id = rows.getColumnItem("TEXT_ID").toString();
         var story = path.site.allcontent.get(id);
         if (!story)
            continue;
         res.write(param.itemprefix);
         openLink(story.href());
         var str = story.title;
         if (!str) {
            res.write("...");
            renderTextPreview(story.getRenderedContentPart("text"), 20);
         }
         else
            res.write(str);
         closeLink();
         res.write(param.itemsuffix + " \n");
      }
   }
   rows.release();
}


/**
 * a not yet sophisticated macro to display a 
 * colorpicker. works in site prefs and story editors
 */

function colorpicker_macro(param) {
   if (!param || !param.name)
      return;

   var param2 = new Object();
   param2.as = "editor";
   param2.width = "10";
   param2.onchange = "setColorPreview('" + param.name + "', this.value);";
   param2.id = "cp1_"+param.name;
   if (!param.text)
      param.text = param.name;
   if (param.color)
   	param.color = renderColorAsString(param.color);

   if (path.story) {
      var obj = path.story;
      param2.part = param.name;
      param.editor = obj.content_macro(param2);
      param.color = obj.getContentPart(param.name);
   }
   else if (path.site) {
      var obj = path.site;
      param.editor = obj[param.name+"_macro"](param2);
      param.color = obj[param.name];
   }
   else
      return;

   renderSkin("colorpickerWidget", param);
}
