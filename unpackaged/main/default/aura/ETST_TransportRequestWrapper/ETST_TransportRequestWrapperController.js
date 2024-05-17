({
    doInit : function(component, event, helper) {
        /*navigator.geolocation.getCurrentPosition(
                (position) => {
                    alert('success'+position.coords.latitude);
                },
                    (error) => {alert('error'+JSON.stringify(error.message))},
                { enableHighAccuracy: false, timeout: 5000}
            );*/
        var url = $A.get('$Resource.ETSTBgLogo');
        component.set('v.backgroundImageURL', url);
        helper.doInit(component, event, helper);
    },
    setLanguage: function(component, event, helper) {
         var url= window.location.pathname;
        component.set('v.lang',event.getParam("lang"));
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
                "url": url+'&lang='+event.getParam("lang")
                
            });
      urlEvent.fire();
        //alert('lang-->'+component.get('v.lang'));
       // $A.get('e.force:refreshView').fire();
     },
    closeModel: function(component, event, helper) {
        component.set('v.needMoreInfo',false);
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
                "url": '/'
                
            });
        urlEvent.fire();
    },
    SubmitDetails: function(component, event, helper) {
        var e1=component.get('v.eid1');
        var e2=component.get('v.eid2');
        var e3=component.get('v.eid3');
        var phone=component.get('v.Phone');
        var eid='784-'+e1+'-'+e2+'-'+e3;
        if(e1!=null && e2!=null && e3!=null)
        { 
            if(e1.length==4 && e2.length==7 && e3.length==1)
            {
                component.set('v.EID', eid);
            }
                
        }
        
        if(!phone.includes("+971"))
        {
            phone='+971'+phone;
            
        }
        if(component.get('v.EID')!=null && phone!=null && phone.length==13){
            component.set('v.Phone',phone);
            helper.updateProfile(component, event, helper);
        }        
        /*else{
            alert('Please enter valid details');
        }*/
            
   }, 
    
    changeFocus1: function(component, event, helper) {
        var e1=component.get('v.eid1');
        if(e1.length==4)
            component.find("eid2").focus();
        
    },
    changeFocus2: function(component, event, helper) {
        
        var e2=component.get('v.eid2');
        if(e2.length==7)
            component.find("eid3").focus();
        
    },
})