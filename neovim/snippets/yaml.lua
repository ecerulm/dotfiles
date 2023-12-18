return {

	s(
		"deployment",
		fmt(
			[[
    ---
    apiversion: apps/v1
    kind: deployment
    metadata:
      name: {name}
      labels:
        app: {name}
    spec:
      replicas: 1
      selector:
        matchLabels:
          app: {name}
      template:
        metadata:
          labels:
            app: {name}
        spec:
          container:
            - name: container-name
              image: nginx:latest
              ports:
                - containerPort: 80
    ---

  ]],
			{
				name = i(1, "deployment-name"),
			},
			{
				repeat_duplicates = true,
			}
		)
	),
	s(
		"service",
		fmt(
			[[
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

  ]],
			{
				a = i(1, "service-name"),
				port = i(2, "port"),
			},
			{
				repeat_duplicates = true,
			}
		)
	),
}
