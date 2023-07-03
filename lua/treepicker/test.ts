const user = {
  type: "object",
  properties: {
    id: {
      type: "string",
      format: "uuid",
    },
    name: {
      type: "string",
    },
    age: {
      type: "number",
      minimum: 0,
    },
  },
};
