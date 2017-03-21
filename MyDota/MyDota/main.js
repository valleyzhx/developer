require("NSBundle,VideoModel,VideoViewController");

defineClass("VideoViewController", {
            startLoadRequest: function(htmlUrl) {
            var bundle = NSBundle.mainBundle().pathForResource_ofType("video", "html");
            var video = self.valueForKey("_videoObject")
            var url = bundle.toJS()+'?videoid='+video.modelID().toJS();
            console.log('uuuuu '+ url);
            self.ORIGstartLoadRequest(url);
            }
            }, {});
