# sf-breg

This package is contains Lightning Web Components and classes for integrating with the [Brønnøysund Registrene](https://data.brreg.no/enhetsregisteret/api/docs/index.html#_eksempel_2_s%C3%B8k_etter_enheter). 

## Features

The search component can be used in a global action or on a lightning page layout.

![image](https://user-images.githubusercontent.com/58025394/171374250-3582d750-1576-48e3-8047-540dcb9a3ba5.png)

The `BregCalloutService` class supports the following methods:

Search for organizations by name-
`searchOrganization(String name)`

Get organization by organization number-
`getOrganization(String organizationNumber)`



## Dependencies
This package is dependent on the following packages:

[sf-integration-base](https://github.com/jordan-mathews/sf-integration-base)

## Installation

1. Install [npm](https://nodejs.org/en/download/)
1. Install [Salesforce DX CLI](https://developer.salesforce.com/tools/sfdxcli)
    - Alternative: `npm install sfdx-cli --global`
1. Clone this repository ([GitHub Desktop](https://desktop.github.com) is recommended for non-developers)
1. Run `npm install` from the project root folder
1. Install [SSDX](https://github.com/navikt/ssdx)
    - **Non-developers may stop after this step**
1. Install [VS Code](https://code.visualstudio.com) (recommended)
    - Install [Salesforce Extension Pack](https://marketplace.visualstudio.com/items?itemName=salesforce.salesforcedx-vscode)
    - **Install recommended plugins!** A notification should appear when opening VS Code. It will prompt you to install recommended plugins.
1. Install [AdoptOpenJDK](https://adoptopenjdk.net) (only version 8 or 11)
1. Open VS Code settings and search for `salesforcedx-vscode-apex`
1. Under `Java Home`, add the following:
    - macOS: `/Library/Java/JavaVirtualMachines/adoptopenjdk-[VERSION_NUMBER].jdk/Contents/Home`
    - Windows: `C:\\Program Files\\AdoptOpenJDK\\jdk-[VERSION_NUMBER]-hotspot`

## Build

To build the project locally follow these steps:

1. If you have not authenticated to a DevHub run `sfdx auth:web:login -d -a production` and the log in.
2. Install sfdx plugin `echo y | sfdx plugins:install sfpowerkit@2.0.1`
3. Create a file in the projects root directory with the name `env.json`

```
{
    "PACKAGE_KEY": "Your Package Key"
}

```

4. Create scratch org, install dependencies and push project source.

```
npm install
npm run mac:build
```
