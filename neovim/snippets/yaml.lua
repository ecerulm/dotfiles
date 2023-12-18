return {

  s("deployment", fmt([[
    apiversion: apps/v1
    kind: deployment

  ]],{

    })),
  s("service", fmt([[
    ---
    apiversion: v1
    kind: service
    metadata:
      name: {a}
    spec:
      selector:
        app: {a}
      ports:
        - protocol: TCP
          port: {port}
          targetPort: {port}
    ---

  ]],{
      a = i(1, "service-name"),
      port = i(2, "port")
    },{
        repeat_duplicates = true
    })),

}
