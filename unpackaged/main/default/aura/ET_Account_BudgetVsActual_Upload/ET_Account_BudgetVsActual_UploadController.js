({
doInit : function(component, event, helper) {
	
},

updateRecords : function (component, event, helper){

	var fileInput = component.find("file").getElement();
	var file = fileInput.files[0];
	alert(file);
	if (file){
		console.log("NextFile");
		var reader = new FileReader();
		reader.readAsText(file,"UTF-8");
		reader.onload = function (evt){
			var csv = evt.target.result;
			var result = helper.CSVtoJSON(component,csv);
			console.log('$$'+result);


			window.setTimeout($A.getCallback(function(){
				helper.UpdateRecord(component,result);
				}), 10);
		}

		reader.onerror = function (evt) {
			//console.log("error reading file");
		}
	}else {
		
		var toastReference = $A.get("e.force:showToast");
		toastReference.setParams({
			"type":"Warning",
			"title":"Warning",
			"message":'Please choose file',
			"mode":"dismissible"
		});
		toastReference.fire();
	}
},

showfiledata: function(component, event, helper){
	var fileInput = component.find("file").getElement();
	var file = fileInput.files[0];
	if (file) {
		component.set("v.showcard", true);
		console.log("Akash csv");
		var reader = new FileReader();
		reader.readAsText(file, "UTF-8");
		reader.onload = function (evt) {
			var csv = evt.target.result;
			var table = document.createElement("table");
			var rows = csv.split("\n");
			for (var i = 0; i < rows.length; i++) {
				var cells = rows[i].split(",");
				if (cells.length > 1) {
					var row = table.insertRow(-1);
					for (var j = 0; j < cells.length; j++) {
						var cell = row.insertCell(-1);
						cell.innerHTML = cells[j];
					}
				}
			}
			var divCSV = document.getElementById("divCSV");
			divCSV.innerHTML = "";
			divCSV.appendChild(table);
		}
		reader.onerror = function (evt) {
			console.log("error reading file");
		}
	}
}, 

})