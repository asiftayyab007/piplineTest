({
    getProjectProfitAndLossAnalysisCalculationData : function(component,event,helper) {
        var action = component.get("c.projectProfitLossAnalysisCalc");
        action.setParams({
            'quoteId': component.get('v.quoteId')
        });

        action.setCallback(this, function(a) {
            var state = a.getState();
             if (state === "SUCCESS"){
                var response=a.getReturnValue();
                console.log('response '+response);
                if(response!=null && response!=undefined){
                   // component.set("v.wrokforceCalcDetails",response.lstQuoteCalcDetails);
                    helper.getPageData(component,event,helper, response);
                    console.log('response ' + JSON.stringify(response));
                    }else{
                        console.log('response is null');
                    }
    
            }
        });
        $A.enqueueAction(action);

    },

    getPageData: function(component,event,helepr,response){
        component.set("v.profitAndLossAnalysisLst", response);
    }

})