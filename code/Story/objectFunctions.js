/**
 * check if story is ok; if true, save changed story
 * @param Obj Object containing the properties needed for creating a new story
 * @param Obj User-Object modifying this story
 * @return Obj Object containing two properties:
 *             - error (boolean): true if error happened, false if everything went fine
 *             - message (String): containing a message to user
 */

function evalStory(param,modifier) {
   var result = new Object();
   if (param.text) {
      var online = parseInt(param.online,10);
      var editableby = parseInt(param.editableby,10);
      if (this.online)
         this.weblog.lastupdate = new Date();
      this.online = (!isNaN(online) ? online : 0);
      this.editableby = (modifier == this.author && !isNaN(editableby) ? editableby : 2);
      this.title = param.title;
      this.text = param.text;
      this.modifytime = new Date();
      this.modifier = modifier;
      this.topic = param.topic ? param.topic : null;
      this.weblog.lastupdate = new Date();
      if (this.online) {
         // href() may not yet work if we changed the topic
         // so we build the redirect URL manually
         if (this.topic)
            result.url = this.weblog.space.href() + this.topic + "/" + this._id;
         else
            result.url = this.href();
      } else
         result.url = this.weblog.stories.href();
      result.message = "The story was updated successfully!";
      result.error = false;
   } else {
      result.message = "You need at least some text!";
      result.error = true;
   }
   return (result);
}

/**
 * function sets story either online or offline
 */

function toggleOnline(newStatus) {
   if (newStatus == "online") {
      this.online = 1;
      this.weblog.lastupdate = new Date();
   } else if (newStatus == "offline")
      this.online = 0;
   return true;
}

/**
 * function returns true/false whether story is online or not
 */

function isOnline() {
   if (parseInt(this.online,10))
      return true;
   return false;
}

/**
 * function evaluates comment and adds it if ok
 */

function evalComment(param,creator) {
   var result = new Object();
   if (!param.text) {
      result.message = "You need at least some text!";
      result.error = true;
   } else {
      var c = new comment();
      c.title = param.title;
      c.text = param.text;
      c.weblog = this.weblog;
      c.story = this;
      c.createtime = c.modifytime = new Date();
      c.author = creator;
      c.online = 1;
      c.ipadress = param.http_remotehost;
      this.add(c);
      this.weblog.lastupdate = new Date();
      result.message = "Your posting was saved successfully!";
      result.error = false;
   }
   return (result);
}

/**
 * function deletes a whole thread
 * @param Obj Comment-Object that should be deleted
 * @return String Message indicating success/failure
 */

function deleteComment(currComment) {
   for (var i=currComment.size();i>0;i--)
      currComment.deleteComment(currComment.get(i-1));
   if (this.remove(currComment))
      return("The comment was deleted successfully!");
   else
      return("Couldn't delete the comment!");
}

/**
 * function checks if the text of the story was already cached
 * and if it's still valid
 * if false, it caches it again
 * @return String cached text of story
 */

function getText() {
   if (this.cache.lrText <= this.modifytime) {
      // cached version of text is too old, so we cache it again
      var s = createSkin(format(activateLinks(this.text)));
      this.allowTextMacros(s);
      this.cache.lrText = new Date();
      this.cache.rText = this.renderSkinAsString(s);
   }
   return (doWikiStuff(this.cache.rText));
}