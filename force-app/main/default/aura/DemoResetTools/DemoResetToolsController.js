({
    doInit : function (component, event, helper) {
        component.set("v.columns", [
            { label: "Records", fieldName: "itemCount", type: "number", initialWidth: 100, cellAttributes: { alignment: "center" } },
            { label: "Demo Reset Tasks", fieldName: "itemLink", type: "url", cellAttributes: { iconName: "standard:task" }, typeAttributes: { label: { fieldName: "itemDescription" }, tooltip: { fieldName: "itemDescription" }, target: "_parent" } }
        ]);
        helper.refreshTaskItems (component, event, helper);
    },
    
    handleRowSelection : function (component, event, helper) {        
        helper.refreshTotals(event.getParam("selectedRows"), component, event, helper);
    },
    
    handleShowModal : function (component, event, helper) {
        component.set("v.modalOpen", true);
    },
    
    handleCancelButton : function (component, event, helper) {
        component.set("v.modalOpen", false);
        component.find("notifLib").showToast({
            message: "No records were deleted" + (component.get("v.runApex") ? " and the custom Apex method was not executed." : "."),
            variant: "info",
            mode: "dismissable"
        });        
    },
    
    handleResetDemoButton : function (component, event, helper) {
        component.set("v.modalOpen", false);
        component.set("v.spinnerVisible", true);
        let resetDemoAction = component.get("c.demoReset");
        let taskItems = [];
        for (const row of component.find("resetItemsTable").getSelectedRows())
            if (!row.itemQueryError && row.itemCount > 0)
                taskItems.push(row.itemId);
        resetDemoAction.setParams({
            taskItems: taskItems,
            runApex: component.get("v.runApex")
        });
        resetDemoAction.setCallback(this, function(response) {
            component.set("v.spinnerVisible", false);
            switch (response.getState()) {
                case "SUCCESS" :
                    helper.refreshTaskItems(component, event, helper);
                    component.set("v.selectedRows", []);
                    component.set("v.totalRecordsSelected", 0);
                    let returnValue = response.getReturnValue();
                    if (returnValue != null)
                    	for (const toast of returnValue)
                        	component.find("notifLib").showToast({
                            	mode: toast.toastMode,
                            	variant: toast.toastVariant,
                            	message: toast.toastMessage
                        	});
                    $A.get('e.force:refreshView').fire();
                    break;
            }
        });
        $A.enqueueAction(resetDemoAction);        
    },
    
    handleRunApexCheckbox : function (component, event, helper) {
        component.set("v.runApex", !component.get("v.runApex"));
    },
    
    handleHelpButton : function (component, event, helper) {
        component.set("v.helpSectionVisible", !component.get("v.helpSectionVisible"));
    }
});