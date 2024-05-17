import { LightningElement, track, api } from 'lwc';
import getTrainerSchedules from '@salesforce/apex/ETDIBookingRequest.getTrainerSchedules';
import getTraineeList from '@salesforce/apex/ETDIBookingRequest.getTraineeList';
import updateTraineeList from '@salesforce/apex/ETDIBookingRequest.updateTraineeList';
import deleteFiles from '@salesforce/apex/ETDIBookingRequest.deleteFiles';
import LWCImages from "@salesforce/resourceUrl/LWCImages";
import { loadStyle, loadScript } from 'lightning/platformResourceLoader';
import getEmployeeList from '@salesforce/apex/ETDIBookingRequest.getEmployeeList';
import addTrainee from '@salesforce/apex/ETDIBookingRequest.addTrainee';
import getRelatedBRDetails from '@salesforce/apex/ETDIBookingRequest.getRelatedBRDetails';

export default class ETDI_TrainerScreen extends LightningElement {
	@track TrainerScheduleList;
	@track showModal = false;
	@track TraineeList = [];
	@track currentScheduleId;
	@track bookingReqId;
	@track bookingRequestStatus;
	@track lstAllFiles = [];
	@track filename;
	@track fileIndex;
	@track theorymark;
	hasTrainerScheduleData = false;
	hasTraineeData = false;
	showAttendenceButton = true;
	bookingRequestId = '';
	bookingRequestName = '';
	@track showAddTraineeModal = false;
	searchValue = '';
	hasEmployees = false;
	@track AccountRecord;
	@track selectedEmployees = [];
	@track TraineeBRid;
	@track showdetailsmodal = false;
	@track selectedScheduleId;
	@track relatedbkId;
	@track bkBranch;
	@track bkProgramName;
	@track bkDepot;
	@track exm;
	@track examReq = false;
	@track fldsItemValues = [];
	@track selectedRecords = [];
	@track tempTraineeList = [];

	renderedCallback() {
		Promise.all([
			loadStyle(this, LWCImages + '/LWC-Images/css/ETExternalStyle.css')

		])
			.then(() => {
				console.log("All scripts and CSS are loaded. perform any initialization function.")
			})
			.catch(error => {
				console.log("failed to load the scripts");
			});
	}

	@track columnsTrainee = [
		{ label: 'Employee No.', fieldName: 'EmployeeId', type: 'text' },
		{ label: 'Employee', fieldName: 'EmployeeName', type: 'text' }
	];

	/* @track couloumsProfTrainee=[
		{ label: 'Employee No.', fieldName: 'EmployeeId', type: 'text' },
		{ label: 'Employee', fieldName: 'EmployeeName', type: 'text' },
		{ label: 'Theoretical', fieldName: 'Theoretical_Marks__c',  type: 'text', editable: true},
		{ label: 'Practical', fieldName: 'Practical_Marks__c',  type: 'text',editable: true},
		{ label: 'Remarks', fieldName: 'Remarks__c',  type: 'text',editable: true}
	] */

	connectedCallback() {
		this.getTrainerScheduleList();

		//loadStyle(this, styles);
	}


	getAllRelatedBRDetails() {

		getRelatedBRDetails(
			{
				bkreqId: this.relatedbkId
			}
		)
			.then(result => {
				result.forEach(item => {
					this.bkBranch = item.Branch__r.Name;
					this.bkProgramName = item.Program_Name__r.Name;
					this.bkDepot = item.Depot__r.Name;
					this.exm = item.Exam_Required__c;
				});
				console.log(result);

			})
			.catch(error => {
				console.log(error);
			});
	}


	getTrainerScheduleList() {

		let currentDate = new Date();
		let formattedcurrentDate = currentDate.toISOString().split('T')[0];


		getTrainerSchedules()
			.then(result => {
				result.forEach(item => {

					let ScheduleDate = new Date(item.Schedule_Date_Time__c);
					let formattedScheduleDate = ScheduleDate.toISOString().split('T')[0];

					if (item.Booking_Request__r.Status__c == 'Approved') {
						item.Booking_Request__r.Status__c = 'Scheduled';
					}
					if (item.Booking_Request__r.Status__c != 'Completed' && formattedScheduleDate == formattedcurrentDate)
						item.showAttendenceBtn = true;
					else
						item.showAttendenceBtn = false;
				});
				console.log('TrainerScheduleList'+result);
				console.log('TrainerScheduleListjson', JSON.stringify(result));


				this.TrainerScheduleList = result;
				if (this.TrainerScheduleList.length > 0)
					this.hasTrainerScheduleData = true;
			})
			.catch(error => {
				console.log(error);
			});
	}

	getTraineeDetails(bkngId) {
		getTraineeList({
			BookingId: bkngId
		})
			.then(result => {
				let tempData1 = [];
				result.forEach(item => {

					if (item.ETDI_Booking_Request__r.Exam_Required__c == 'Yes') {
						this.examReq = true;
					}


					let traineeObj = new Object();
					traineeObj.sobjectType = 'ETDI_Trainees__c';
					traineeObj.Id = item.Id;
					traineeObj.EmpName = item.Employee__r.Name;
					traineeObj.EmpId = item.Employee__r.ETIN_Employee_Id__c
					traineeObj.Theoretical_Marks__c = 0;
					traineeObj.Practical_Marks__c = 0;
					traineeObj.Remarks__c = '';
					this.TraineeList.push(traineeObj);

					let traineeObj2 = new Object();
					traineeObj2.sobjectType = 'ETDI_Trainees__c';
					traineeObj2.Id = item.Id;
					traineeObj2.Theoretical_Marks__c = 0;
					traineeObj2.Practical_Marks__c = 0;
					traineeObj2.Remarks__c = '';
					traineeObj2.Attended__c = false;
					this.tempTraineeList.push(traineeObj2);

				});



				if (this.TraineeList.length > 0)
					this.hasTraineeData = true;
				else
					this.hasTraineeData = false;

			})
			.catch(error => {
				console.log(error);
			});
	}

	hanldeAttendenceButton(event) {
		this.showModal = true;
		const bookingId = event.target.dataset.id;
		this.currentScheduleId = event.target.dataset.schid;
		this.bookingReqId = event.target.dataset.id;

		this.getTraineeDetails(bookingId);
	}

	hanldeAddTraineeButton(event) {
		this.showAddTraineeModal = true;
		this.TraineeBRid = event.target.dataset.brid;
	}

	closeAddTraineeModal() {
		this.showAddTraineeModal = false;
		this.searchValue = '';
		this.selectedEmployees = [];
		this.hasEmployees = false;
	}

	cancel() {
		this.showModal = false;
		this.TraineeList = [];
		this.tempTraineeList = [];
	}

	handleSave(event) {

		updateTraineeList({
			TraineeList: this.tempTraineeList,
			bookingId: this.bookingReqId
		})
			.then(result => {

				this.showModal = false;
				this.getTrainerScheduleList();
			})
			.catch(error => {
				console.log(error);
			});

	}

	handleUploadFinished(event) {
		// Get the list of uploaded files
		const lstUploadedFiles = event.detail.files;
		lstUploadedFiles.forEach(item => this.lstAllFiles.push({ filename: item.name, fileid: item.documentId }));

	}

	deleteattachment(event) {

		this.fileIndex = event.target.dataset.num;
		this.lstAllFiles.splice(this.fileIndex, 1);
		deleteFiles({
			contentDocId: event.target.name
		}).then(result => {
			console.log('result:' + result);

		})
			.catch(error => {
				console.log(error);
			});

	}

	searchKeyword(event) {

		this.searchValue = event.target.value;

	}

	handleSearchKeyword() {

		if (this.searchValue != '') {

			getEmployeeList({
				searchKey: this.searchValue
			})
				.then(result => {
					// set @track contacts variable with return contact list from server  
					this.AccountRecord = result;
					if (result.length > 0)
						this.hasEmployees = true;
				})
				.catch(error => {

					const event = new ShowToastEvent({
						title: 'Error',
						variant: 'error',
						message: error.body.message,
					});
					this.dispatchEvent(events);
					// reset contacts var with null   
					this.AccountRecord = null;
				});
		} else {
			// fire toast event if input field is blank
			const event = new ShowToastEvent({
				title: 'Data not found',
				variant: 'error',
				message: 'please enter a valid name'
			});
			this.dispatchEvent(events);
		}
		if (this.AccountRecord == null) {
			const event = new ShowToastEvent({
				title: 'Data not found',
				variant: 'error',
				message: 'please enter a valid name'
			});
		}
	}

	handleCheckboxChange(event) {


		if (event.target.checked) {
			event.target.checked = true;

			let nameVal = event.target.name;

			this.AccountRecord.forEach(item => {

				if (item.Id == nameVal)
					this.selectedEmployees.push(item);

			})


		}


	}

	onEmpRemove(event) {
		let selEmp = event.target.name;
		const removeIndex = this.selectedEmployees.findIndex(item => item.Id == selEmp.Id);
		this.selectedEmployees.splice(removeIndex, 1);


	}

	handleAddTrainee() {
		addTrainee({
			empList: this.selectedEmployees,
			bkreqId: this.TraineeBRid
		})
			.then(result => {

				if (result == 'SUCCESS') {
					this.showSpinner = false;
					this.showAddTraineeModal = false;
					this.searchValue = '';
					this.selectedEmployees = [];
					this.hasEmployees = false;
					const events = new ShowToastEvent({
						title: "Successful",
						message: "Trainees Added Successfully",
						variant: 'success'
					});
					this.dispatchEvent(events);
					this.getBookingRequest();
				} else {
					this.showSpinner = false;
					const events = new ShowToastEvent({
						title: "Error",
						message: "Please check with system admin",
						variant: 'error'
					});
					this.dispatchEvent(events);

				}

			}).catch(error => {
				console.log(error);

			});
	}

	handleSelectSchedule(event) {
		this.showdetailsmodal = true;
		this.selectedScheduleId = event.currentTarget.dataset.trschid;
		this.relatedbkId = event.currentTarget.dataset.bkid;
		//let schid=event.currentTarget.dataset.trschid;

		this.getAllRelatedBRDetails();

	}

	closeDetailsModal() {
		this.showdetailsmodal = false;
	}


	traineeFieldChange(event) {
		let fieldName = event.target.name;
		let index = event.target.dataset.index;

		if (fieldName == 'Attended__c')
			this.tempTraineeList[index][fieldName] = event.target.checked;
		else
			this.tempTraineeList[index][fieldName] = event.target.value;


	}




}