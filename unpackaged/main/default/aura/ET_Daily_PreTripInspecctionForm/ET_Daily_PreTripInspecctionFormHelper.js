({
	 getTodayDate: function(component, event) {
        var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
    component.set('v.today', today);
    },
    
    

})