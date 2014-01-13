# Fake Aixforce Web Container

## requirements

- nodejs: ~0.10 (with npm)

## usage

First, install jigglypuff use git repo url or local path.

`npm i -g git+ssh://#{git repo url here}`

`npm i -g ~/dev/jigglypuff`

Second, run it.

`jiggly`

## config

jigglypuff can accept a config file named `jiggly.json` under the work path.

### options

All options has default value below:

    {
      "serverPort": 8080,
      "filesHome": "public",
      "viewsHome": "public/views",
      "componentsHome": "public/components"
    }

The config file (`jiggly.json`) can include multiple option groups. The group which will be loaded depend on env variable `NODE_ENV`.

ex:

    {
      "dev": {
        "serverPort": 8081
      },
      "prod": {
        "serverPort": 80
      }
    }

All unset options will use the default value.

## workflow

1. leave all `.js` files in `lib/` folder there
2. write code with coffee in `src/` folder
3. write test code with coffee in `test/` folder
4. run `npm test`, make sure all tests passed
5. use `npm run-script compile` to compile coffee to js
6. commit and push to git

To compile and install the repo, use `npm run-script build`.