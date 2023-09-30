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
To run the test cases, you can either use VSCode or the ECL IDE as your preferred IDE. I used the ECL IDE, so I will explain in terms of the ECL IDE.
You need to install the ECL IDE, and set up the Configuration to the specific cluster you're going to be testing on, if you're using the standard cluster, use standard configurations.
How to set up the standard configuration
Once you have your Azure Kubernetes Cluster running you can use the command kubectl get svc and under the Name column search for eclqueries and eclwatch, corresponding to each eclqueries and eclwatch, under the coloumn External-IP and Port(s). On your browser, copy and paste (External-IP : first-four number in Port)

For example, if I execute the command kubectl get svc, I should get a similar result
```
NAME                   TYPE           CLUSTER-IP       EXTERNAL-IP   PORT(S)          AGE
dfs                    LoadBalancer   10.99.207.137    localhost     8520:31798/TCP   3d
eclqueries             LoadBalancer   10.107.94.169    localhost     8002:30536/TCP   3d
eclservices            ClusterIP      10.109.119.30    <none>        8010/TCP         3d
eclwatch               LoadBalancer   10.99.173.46     localhost     8010:31466/TCP   3d
esdl-sandbox           LoadBalancer   10.98.34.87      localhost     8899:30557/TCP   3d
kubernetes             ClusterIP      10.96.0.1        <none>        443/TCP          3d
mydali                 ClusterIP      10.111.199.248   <none>        7070/TCP         3d
roxie                  LoadBalancer   10.99.180.146    localhost     9876:32605/TCP   3d
roxie-toposerver       ClusterIP      None             <none>        9004/TCP         3d
sasha-coalescer        ClusterIP      10.108.21.199    <none>        8877/TCP         3d
sasha-dfuwu-archiver   ClusterIP      10.107.87.128    <none>        8877/TCP         3d
sasha-wu-archiver      ClusterIP      10.100.80.155    <none>        8877/TCP         3d
spray-service          ClusterIP      10.98.197.131    <none>        7300/TCP         3d
sql2ecl                LoadBalancer   10.101.246.137   localhost     8510:31740/TCP   3d

```
To access ECLWatch and ECLQueries
eclqueries: localhost:8002
elcwatch: localhost:8010

Now, that you have access to these pages you can then open your ECL IDE, build your dataset on Thor cluster, and publish your query on Roxie. 

You can access the ECLWatch to see if your files are running properly and no suspension or any other error is occurring. 

Once the query file is published, you may head over to the ECL Query page, click on Roxie, and open your file, and input the parameters. You can input Georgia in the state field and select Capture Log Info and submit. After your results have been displayed, go back to your preferred Terminal window, set the file path directory to your preferred file directory in order to save log information in a file and type the command kubectl logs podname > filename.txt or filename.log (In order to attain the podname, you can execute kubectl get pods to view the specific roxie-agent pod to get the podname)

```
C:\Windows\System32>kubectl get pods
NAME                                          READY   STATUS    RESTARTS         AGE
dfs-7c58768767-nttll                          1/1     Running   86 (115m ago)    3d
dfuserver-bd86b5787-g5gvd                     1/1     Running   86 (115m ago)    3d
eclqueries-7f886fbb45-5gdfn                   1/1     Running   86 (115m ago)    3d
eclscheduler-9d98b775b-4vwn8                  1/1     Running   86 (115m ago)    3d
eclservices-67676c8498-btgk4                  1/1     Running   86 (115m ago)    3d
eclwatch-858bfc4df5-r7wk2                     1/1     Running   86 (115m ago)    3d
esdl-sandbox-6454f89897-6gm5d                 1/1     Running   86 (115m ago)    3d
hthor-7dd564cc99-lqntv                        1/1     Running   86 (115m ago)    3d
mydali-6fb974fb57-dgxrh                       2/2     Running   170 (115m ago)   3d
myeclccserver-678f5d5b95-fppn7                1/1     Running   86 (115m ago)    3d
roxie-agent-1-67b7b75888-rzp8b                1/1     Running   85 (115m ago)    3d
roxie-toposerver-684df87889-dtfl6             1/1     Running   85 (115m ago)    3d
roxie-workunit-54fd77fcb9-wgwv7               1/1     Running   86 (115m ago)    3d
sasha-dfurecovery-archiver-7cd99698d4-n6l72   1/1     Running   85 (115m ago)    3d
sasha-dfuwu-archiver-659b9944fb-xrb2q         1/1     Running   85 (115m ago)    3d
sasha-file-expiry-5484f78566-mp7pr            1/1     Running   85 (115m ago)    3d
sasha-wu-archiver-56d548db6b-6zzvt            1/1     Running   85 (115m ago)    3d
spray-service-56894dbd76-w58s6                1/1     Running   85 (115m ago)    3d
sql2ecl-79fc4955d9-kxgs2                      1/1     Running   86 (115m ago)    3d
thor-eclagent-79795966f8-dvqwq                1/1     Running   86 (115m ago)    3d
thor-thoragent-648b578fb9-l5d6p               1/1     Running   86 (115m ago)    3d

(In your Terminal Window, an example of a file directory would be cd C:\HPCC\LogFiles\)

C:\HPCC\LogFiles\> kubectl logs roxie-agent-1-67b7b75888-rzp8b > logOne.txt
```
You can now go back to ECL Query page, and run another test cases to collect a batch by retyping Georgia in the state field, selecting Capture Log Info and submit, and repeat the commands again. Make sure you execute kubectl logs podname > filename.txt every time you do a test case such as inputting Georgia in the field etc, so the data is captured sequentially. 

Once you have a batch of test cases ready, you may now use the Python Script that I published in this repo, and save it as .py in the same file directory along with your Log Files folders, and run the Python file to parse through the log files and extract the needed information. 

Now, you can open the Excel file and analyze the data from the Log File.




