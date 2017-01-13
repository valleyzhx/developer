require("UMOnlineConfig",);

defineClass("M3U8Tool", {
            webViewDidFinishLoad: function(webView) {
            var videoJS = UMOnlineConfig.getConfigParams("videojs");
            var type = self.valueForKey("_type")     //get member variables

            var lJs = videoJS.stringByAppendingFormat("getVideoM3u8('%@');", type);
            
            var html = webView.stringByEvaluatingJavaScriptFromString(lJs);
            self.setValue_forKey(html,"_lHtml");
            var lHtml = self.valueForKey("_lHtml")     //get member variables
            
            var finished = self.valueForKey("finished")     //get member variables
            
            if (lHtml.length()&&finished) {
            finished(lHtml);
            finished = null;
            }
            }
            }, {});
