module.exports = {
  urls: {
    "/api/test": 1,
    "/api/test2": function(params) {
      return params;
    }
  },
  comps: {
    "test/comp": {
      a: 1,
      b: 2
    },
    "test/comp2": function(params) {
      return {
        a: params.a,
        b: params.b
      };
    }
  },
  globals: {
    "_USER_": { id: 1, name: "anson0370" }
  }
};
