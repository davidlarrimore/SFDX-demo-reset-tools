# Demo Reset Tools

This package contains tabs, Lightning pages, Lightning components, and other support to help me reset my orgs between demo runs.

![Demo Reset Tools](images/DemoReset.gif)

## Motivation

I often find myself in a situation where I need to dust off a demo long after I originally presented it and have forgotten if certain records are required for the demo, were generated during my testing, or were created during the last presentation, thus making any reset of the demo to a clean state for the next presentation more time-consuming and risky.

I was inspired by Salesforce uber-SE John Schillaci to create this Lightning component, which simply executes a number of record deletion tasks (called "Demo Reset Tasks") based on criteria specified in a SOQL WHERE clause.  Optionally, the component will follow up the deletions with an invocation of a custom Apex class which can handle any other reset operations that do not involve simple deletions.

## How to Set Up

Once the package is deployed, you will need to create a Lightning app page with the Lightning App Builder and drag the `Reset the Demo` custom component on the page where you would like to place it. Since you will have no demo reset tasks defined at this point, your component will look like this:

![Blank Demo Reset Tools](/images/Blank_Demo_Reset.png)

Next, open the App Launcher and click on the `Demo Reset Tasks` tab and click the `New` button and supply the object API name, a description, and an optional SOQL WHERE clause which specifies which records of that object should be deleted. Repeat for all of the objects whose records you would like to delete.

If you are familiar with [Apex](https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_intro_what_is_apex.htm) you can modify the supplied `DemoResetCustomApex.runCustomApex` method to perform any other operations that can't be done with simple record deletions, such as deactivating users.


## How to Deploy This Package to Your Org

I am a pre-sales Solutions Engineer for [Salesforce](https://www.salesforce.com) and I develop solutions for my customers to demonstrate the capabilities of the amazing Salesforce platform. *This package represents functionality that I have used for demonstration purposes  and the content herein is definitely not ready for actual production use; specifically, it has not been tested extensively nor has it been written with security and access controls in mind. By installing this package, you assume all risk for any consequences and agree not to hold me or my company liable.*  If you are OK with that ...

Simply click the button below and log into your org:

<a href="https://githubsfdeploy.herokuapp.com">
  <img alt="Deploy to Salesforce"
       src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/src/main/webapp/resources/img/deploy.png">
</a>