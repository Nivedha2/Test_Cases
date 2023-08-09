# Test_Cases
The subdirectories contain all the ECL files I have used to execute the test cases.
# Tools needed to set up your cluster and other applications
Terminal, Git, Azure Command Line, Kubectl, Helm, Terraform, ECL IDE, VSCode
# Start your cluster
Once you have installed all the tools, you are now ready to start your cluster.
Now your Command Prompt, or any preferred terminal window, type the command **az login** to login into your Azure account
  You can use **az account show** to view the current Azure account you're using. <br>
  You can follow Godji's Blog [**Getting Started with the HPCC Systems Cloud Native Platform Using Terraform and Azure**](https://hpccsystems.com/resources/getting-started-with-the-hpcc-systems-cloud-native-platform-using-terraform-and-azure/) to download Godji's Terraform Repository. <br>
  But before you execute the terraform commands, you need to add the section below and save it in the esp.yaml file which is found inside values folder in the terraform-azzure-hpcc folder. You also need to change the name and email in your admin block in each of your admin.tfvars file to your own customized name and email. Also, in the aks_automation block in admin.tfvars in the AKS module, change automation_account_name to your a different name everytime you have more than one cluster running at one time.
   
```roxie:
- name: roxie
  disabled: false
  prefix: roxie
  services:
  - name: roxie
    servicePort: 9876
    listenQueue: 200
    numThreads: 30
    visibility: local
    # Can override ingress rules for each service if desired - for example to add no additional ingress permissions you can use
    # ingress: []
  ## replicas indicates the number of replicas per channel
  replicas: 1
  numChannels: 1
  ## Set serverReplicas to indicate a separate replicaSet of roxie servers, with agent nodes not acting as servers
  serverReplicas: 0
  ## Set localAgent to true for a scalable cluster of "single-node" roxie servers, each implementing all channels locally
  localAgent: false
  ## Adjust traceLevel to taste (1 is default)
  traceLevel: 3
  ## Set mtuPayload to the maximum amount of data Roxie will put in a single packet. This should be just less than the system MTU. Default is 1400
  # mtuPayload: 3800
  #channelResources:
  #  cpu: "4"
  #  memory: "4G"
  #serverResources:
  #  cpu: "1"
  #  memory: "1G"
  # Roxie may take a while to start up if there are a lot of queries to load. Yuo may need to 
  #override the default startup/readiness probing by setting these values
  #minStartupTime: 30      # How long to wait before initiating startup probing
  #maxStartupTime: 600     # Maximum time to wait for startup to complete before failing
  topoServer:
    replicas: 1
  #directAccessPlanes: []  #add direct access planes that roxie will read from without copying the data to its default data plane
```

# Setting up Test Cases
