({
    
    doInit: function(component,event,helper){
        var url_string = window.location.href;
        var url = new URL(url_string);
        var RecordId = url.searchParams.get("recordId"); 
        if(RecordId != null && RecordId != '' && RecordId != undefined){
            helper.UserPermissions(component,event,helper);
           // helper.getSObjectName(component,RecordId,helper);
        }
        
    },
    

    updateSelectedTabs : function(component, event, helper) {
        debugger;
        var selectedCheckbox = event.getSource().getLocalId();
       // console.log(selectedCheckbox);
        //console.log('From Aura Id ',component.find(selectedCheckbox).get("v.checked"));
        var selected = component.find(selectedCheckbox).get("v.checked");
        helper.updateTabs(component,selectedCheckbox,selected);
            //event.getSource().get("v.value");
        //console.log(selected);
        
       
    },

   
    setSelectedTab: function(component,event,helper){
        debugger;
        var args = event.getParam("arguments");
        var selectedTab = args.selectedTab;
        var selected = args.selected;
        (component.find(selectedTab)).set("v.checked",selected);
        helper.updateTabs(component,selectedTab,selected);
    }
})