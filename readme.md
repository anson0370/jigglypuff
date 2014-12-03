# Fake Aixforce Web Container

## requirements

- nodejs: ~0.10 (with npm)

## usage

First, install jigglypuff use git repo url or local path.

`npm install -g jigglypuff`

Second, run it.

`jiggly`

help:

`jiggly -h`

## config

jigglypuff can accept a config file named `jiggly.json` under the work path.

### options

All options has default value below:

    {
      "serverPort": 8080,
      "filesHome": "public",
      "viewsHome": "public/views",
      "componentsHome": "public/components",
      "dataFile": [],
      "extraHelpers": [],
      "oldMode": false,
      "pageMode": false
    }

The config file (`jiggly.json`) can include multiple option groups. Depend on env variable `NODE_ENV`, one group will be loaded.

ex:

    {
      filesHome: "public",
      "env": {
        "dev": {
          "serverPort": 8081
        },
        "prod": {
          "serverPort": 80
        }
      }
    }

All unset options will use the default value.

## workflow

1. leave all `.js` files in `lib/` folder there
2. write code with coffee in `src/` folder
3. write test code with coffee in `test/` folder
4. run `npm test`, make sure all tests passed
5. use `npm run compile` to compile coffee to js
6. commit and push to git

To compile and install the repo, use `npm run build`.

### use mock data

Write a `.js` file and setting the option `dataFile` to point to it.

The data file may like below:

    module.exports = {
      "/api/test": {
        data1: "some data",
        data2: "some data2",
        data3: ["11", "22", "33"]
      },
      "/api/test2": function(params, method) { // method: GET, POST, PUT, DELETE...
        return {
          data1: params.p1,
          data2: params.p2
        };
      }
    }

Export your datas with url:object/function pair. And if functions provided, all the request params in form and query will be passed in.
