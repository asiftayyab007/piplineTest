({
	handleSearch : function(component, event, helper) {
       helper.getOpportunities(component);

	},
     doInit : function(component, event, helper) {
        // Fetch opportunity records
    },
     
    handleSelect : function(component, event, helper) {
        // Get selected opportunities
        var recordId = event.currentTarget.getAttribute("data-recordid");
        console.log('Current record id: ' + recordId);
        let allOps=component.get('v.opportunities');
        allOps.forEach(function(item){
            if(item.Id==recordId){
                component.set("v.selectedOpp",item);
               return false;
                
            }
        });
        
        //var selectedOpp = [];
        // selectedOpp.push(recordId);
        component.set("v.HomePage",false);
        component.set("v.vehSearchPage",false);
        component.set("v.vehInspectionForm",true);
       
    },
    WalkIn : function(component, event, helper) {
    },
    Appointment : function(component, event, helper) {
       component.set("v.HomePage",false);
       component.set("v.vehSearchPage",true);
    },
     Home : function(component, event, helper) {
         component.set("v.HomePage",true);
         component.set("v.vehSearchPage",false);
         component.set("v.vehInspectionForm",false);
    },
    handleLikeButtonClick : function (cmp,event) {
        let data = event.getSource().get("v.name");       
       
        cmp.set('v.'+data,true);
         alert(data+'--'+val)
    },
    handleDisLikeButtonClick : function (cmp,event) {
        let data = event.getSource().get("v.name");
        cmp.set('v.'+data,false);
    }
    
})