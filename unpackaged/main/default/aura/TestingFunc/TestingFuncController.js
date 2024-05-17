({
	handleLikeButtonClick : function (cmp,event) {
       let data = event.getSource().get("v.name");
      
        cmp.set('v.'+data,true);
    },
    handleDisLikeButtonClick : function (cmp,event) {
          let data = event.getSource().get("v.name");
         cmp.set('v.'+data,false);
        
    }
    
})