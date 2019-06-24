@isTest
private class a_MyClass_Test {

    @isTest
    static void myUnitTest() {
        a_MyClass demo = new a_MyClass();
        System.assertEquals(demo.getAppVersion(), '1.0.0');
        // Uncomment the following line to cause a build failure
        // System.assert(false);
    }
}
