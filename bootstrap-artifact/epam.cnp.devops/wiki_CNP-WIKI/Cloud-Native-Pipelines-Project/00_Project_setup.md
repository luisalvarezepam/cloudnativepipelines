[[_TOC_]]

# Overview

To start application development with this solution, basically you don't need any pre-deployment code preparation (or it is very limited). But still, we recommend you to explore and modify infrastructure and application configurations according to your requirements.

# Prerequisites

- Azure DevOps (ADO) organization. You can [create an organization](https://learn.microsoft.com/en-us/azure/devops/organizations/accounts/create-organization?view=azure-devops) for free under EPAM account
- Azure Cloud subscription. You can use an Azure subscription provided with [Visual Studio Professional subscription benefit](https://my.visualstudio.com/Benefits?mkt=en-us) or [Create Azure free account](https://azure.microsoft.com/en-us/free/)

# Deployment steps

1.  [Create an Azure AD app and service principal in the portal](https://learn.microsoft.com/en-us/cli/azure/create-an-azure-service-principal-azure-cli) with Owner role assignment to your Azure subscription 

2. Install the following extensions into your ADO organization:  
  * [Replace Tokens](https://marketplace.visualstudio.com/items?itemName=qetza.replacetokens)
  * [Azure Pipelines Terraform Tasks](https://marketplace.visualstudio.com/items?itemName=ms-devlabs.custom-terraform-tasks)
  * [SonarCloud](https://marketplace.visualstudio.com/items?itemName=SonarSource.sonarcloud&targetId=501105ea-146a-4ef7-8f0e-54de940c1f3c&utm_source=vstsproduct&utm_medium=ExtHubManageList) 
3. Unzip bootstrap artifacts and deploy `Core and Apps Cloud Native Pipelines` projects into your organization<br>
Please select `gitflow` workflow and environment approval enabled, e.g.
```
.\bootstrap.ps1 -targetOrg https://dev.azure.com/{YOUR_ORG_NAME}/ -workflow "gitflow" -envApproveEnable $true -securityGroupName "{YOUR_SECURITY_GROUP_NAME}"
```
Please use `README.html` in the root of the downloaded artifacts folder as importing guide

4. After the import completion open your Azure Devops organization and verify that 2 `Cloud Native Pipelines` projects have been imported:
- Core: `#{project_name}#`
- Apps: `#{project_name}#.app.v1`

5. In the `#{project_name}#.app.v1` project- navigate to `Pipelines\Library` and update the System variable group (sys.global):
- [ ] SYS_CODE_READ_PAT  - generate PAT token with (Code (Read) rights) in the organization where your Devops project exists and insert value as secure string. Also the value of this PAT token you will use for the `Azure Repos/Team Foundation Server service connection` in the following step.
- [ ] SYS_OPS_RW_PAT - generate PAT token with (Build (Read & execute); Environment (Read & manage); Service Connections (Read, query, & manage); Variable Groups (Read, create, & manage)) in the organization where your application project exists and insert value as secure string.
 
6. In `#{project_name}#.app.v1` project create [Azure Repos/Team Foundation Server service connection](https://learn.microsoft.com/en-us/azure/devops/pipelines/library/service-endpoints?view=azure-devops&tabs=yaml#azure-repos) named `tfs_cnpdevopsproject` with reference to your organization (such loopback connection is needed if Core and Apps project are deployed in same organization). As a PAT token use the token which was generated in the previous step for `SYS_CODE_READ_PAT`.

7. In the `#{project_name}#.app.v1` project create [Azure Resource Manager service connection](https://learn.microsoft.com/en-us/azure/devops/pipelines/library/service-endpoints?view=azure-devops&tabs=yaml#azure-resource-manager-service-connection) to your Azure Cloud subscription.

8. In the `#{project_name}#.app.v1` project- navigate to `Pipelines\Library` and update the following variables

- Common environment variable group (the variable group which matches `*.com.env.*` name)
- [ ] ENV_APP_ALERTS_RECEIVERS_EMAIL - update with your own email address;
- [ ] ENV_CERT_MANAGER_ISSUER_EMAIL - update with your own email address;
- [ ] ENV_AZURE_CLIENT_ID – update with your Azure Cloud SP client ID;
- [ ] ENV_AZURE_CLIENT_SECRET – update with your Azure Cloud SP client secret (make sure the secret is masked as secure string);
- [ ] ENV_AZURE_SUBSCRIPTION_ID – update with your Azure Cloud subscription ID;
- [ ] ENV_AZURE_TENANT_ID – update with your Azure Cloud tenant ID;
- [ ] ENV_SERVICE_CONNECTION_NAME – update with Azure Cloud service connection name that was created in the step above;
- [ ] ENV_TF_STATE_STORAGE_ACCOUNT_NAME – update with desired Azure Cloud storage account name to store terraform state files (it must be globally unique name);
- [ ] ENV_TF_STATE_SUBSCRIPTION_ID – update with your Azure Cloud subscription ID to store Terraform state file;

- Production variable group (the variable group which matches `*.prod.env.*` name):
- [ ] ENV_INFRA_NAME_PREFIX – change value to some unique string (use letters and numbers);

9.  In the `#{project_name}#.app.v1` project navigate to `Pipelines\Library` and change `{Owner}` and `{Name}` parts of the Variable Group names your specific values for each Variable Group. Please see [naming convention](/EPAM-Cloud-Native-Pipelines-Accelerator/Solution-overview/Governance/Naming-convention.md) for details

10. In the `#{project_name}#.app.v1` project navigate to `epam.cnp.todoapp` Git repo and in the source code under `pipelines\_configuration` rename Terraform configuration files (.tfvars files) according to changes you made to Variable Group names (you may need to temporarily disable the policies to `develop` branch in order to be able to comit to the branch diractly) <br>
The Terraform configuration must have `{Environment_Variable_Group_Name}.tfvars` file names.<br>
Let's assume that we need to deploy infrastructure components for environment called `test`. So we have a variable group called `company.test.env.myazuresubscription`. Terraform configuration file must be named `company.test.env.myazuresubscription.tfvars`.

11. In the `#{project_name}#.app.v1` project navigate to `epam.cnp.todoapp` Git repo and in the source code under `pipelines\` update each pipeline according to Varable Group new names:
- Update Variable Group names 
- Update environment configuration
- Update pool name in all pipeline files in "application project". Example
 <div style="background-color:rgb(230, 230, 230);white-space:pre">pool:
  vmImage: ubuntu-latest
</div>

12. In the `#{project_name}#.app.v1` project navigate to `Pipelines\Environments` and configure approvals for <strong>dev, qa</strong> and <strong>prod</strong> environments (use any ADO group for it).

13. In the `#{project_name}#.app.v1` project navigate to `Pipelines\Environments` and create infrastructure based ADO environments with the same names as infrastructure based variable groups, but '.' symbols must be replaced with '_' symbol. For example:<br>
For infrastructure based variable group called <strong>company.test.env.myazuresubscription</strong> we must create ADO environment with name <strong>company_test_env_myazuresubscription</strong>. This is because of ADO environment's naming restrictions.

14. In the `#{project_name}#.app.v1` project navigate to `Repos\Branches` of `epam.cnp.todoapp` repo and create branches and assign branch policies to organize CI/CD strategy (please check CI/CD concepts [overview](/EPAM-Cloud-Native-Pipelines-Accelerator/Demonstration-concepts/#{project_name}#.app.v1/Application-delivery-model.md)).

At the end, you are able to deploy infrastructure and application components using "application project" pipelines.