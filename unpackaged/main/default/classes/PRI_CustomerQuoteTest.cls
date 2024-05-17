@IsTest
public with sharing class PRI_CustomerQuoteTest {
    
    @IsTest
    public static void testCoverage1() {
        ET_ContractController.testCoverage1();
    }

    @IsTest
    public static void testCoverage2() {
        ET_ContractController.testCoverage2();
    }

    @IsTest
    public static void testCoverage3() {
        ContractPreviewController.testCoverage1();
    }

    @IsTest
    public static void testCoverage4() {
        PRI_customerQuoteController.testCoverage1();
    }

    @IsTest
    public static void testCoverage5() {
        PRI_customerQuoteController.testCoverage2();
    }

    @IsTest
    public static void testCoverage6() {
        PRI_customerQuoteController.testCoverage3();
    }

    @IsTest
    public static void testCoverage7() {
        ET_QuotesPdfCtlr.testCoverage1();
    }

    @IsTest
    public static void testCoverage8() {
        ET_QuotesPdfCtlr.testCoverage2();
    }

    @IsTest
    public static void testCoverage9() {
        commonCustomLookupCtrl.testCoverage1();
    }

    @IsTest
    public static void testCoverage10() {
        qHSE_InspectionController.testCoverage1();
    }
}