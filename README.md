# Self Hosted Action Runners on Kubernetes
This repository is just a documentation of a journey on a question I had, and that question was:

> "Can I run self-hosted GitHub Action runners on Kubernetes?"

The results may shock you!

I'll probably do this in the future if building Noelware's products or services requires a lot of CPU or Memory Usage on the online hosted instance or if I wanted to do native ARM builds, stay tuned if I build a Helm Chart + Docker Image of them!

## WARNING
Please... for the love god don't do this unless you really want to like I wanted to.

## How did I get this thing running?
### First Steps
The first steps was to get a Docker image running! I had to get myself a copy of the runner itself so it can be used in the image, so I used [Noelware](https://github.com/Noelware) as a test for this!

I went into "Settings > Actions > Runners" and clicked on "New Runner"

![](https://i-am.floof.gay/images/df74dd72.png)

Then, I created a runner using **Linux x64**:

![](https://i-am.floof.gay/images/9628c34c.png)

### Docker Image
You can build the Docker image using the following command:

```shell
$ docker buildx build . -t owo/uwu:latest
```

This will use **buildx** to build the image (which is faster and a lot cooler) and you should have a sufficient image to run at `owo/uwu:latest` or whatever image tag you used.

...and this took some time to do:

![](https://i-am.floof.gay/images/b7e08818.png)

### Test Runner
I tested the runner on my machine before deploying the image to Kubernetes:

```shell
$ docker run -d --name selfhosted-runner --env ORGANIZATION=Noelware --env AUTH_TOKEN=... owo/uwu:latest
```

Now, we have a self-hosted instance running for testing:

![](https://i-am.floof.gay/images/d1db1370.png)

Next step is to test it on a repository! Let's build [hazel](https://github.com/auguwu/hazel) with this!

### Test #2: Actually running it
Now, for testing, I decided to use [hazel](https://github.com/auguwu/hazel) with some modifications in [`.github/workflows/lint.yml`](https://github.com/Noelware/hazel/blob/master/.github/workflows/lint.yml) to use our self-hosted runner:

| `Noelware/hazel`                                | `auguwu/hazel`                                  |
| ----------------------------------------------- | ----------------------------------------------- |
| ![](https://i-am.floof.gay/images/155533b3.png) | ![](https://i-am.floof.gay/images/6c78fb1b.png) |

Since we aren't actually pushing, we should use the `Workflow Dispatch` event from clicking this quirky button:

![](https://i-am.floof.gay/images/12c89e5f.png)

...wait, is it NOT WORKING?!

![](https://i-am.floof.gay/images/515a5799.png)
![](https://i-am.floof.gay/images/c51705e9.png)

back to the drawing board I see! Maybe the dispatch event didn't work, let's pushing to it.

It worked after some tinkering:

```shell
Current runner version: '2.290.1'
2022-05-01 04:56:46Z: Listening for Jobs
2022-05-01 04:58:58Z: Running job: Linting and Unit Tests
2022-05-01 05:03:16Z: Job Linting and Unit Tests completed with result: Failed
```

You can view the run [here](https://github.com/Noelware/hazel/actions/runs/2252248421) but after 90 days, the logs will be cleaned out.

Now, it's time for the Kubernetes StatefulSet time!

### Kubernetes
Now that we know that the Docker image is done, we can ship this to a private registry! For now, you can push this to any registry (if you dare use this which I DO NOT RECOMMEND!), I'll be using my local one: `registry.floofy.dev`

```shell
/mnt/storage/Projects/Misc/Memes/action-k8s (master*) » docker buildx build . -t registry.floofy.dev/github/runner:2.290.1
[... stuff here ...]

 => exporting to image 4.9s
 => => exporting layers 4.8s
 => => writing image sha256:f0dcaea6eb65f6855497bd92fef7c750806b325075a971fb662f6d68f0595f9 0.0s
 => => naming to registry.floofy.dev/github/runner:2.290.1   
```

Now, let's push it and build our [StatefulSet](./statefulset.yml)!

Now, it's successfully pushed on Kubernetes:

![](https://i-am.floof.gay/images/2266aad5.png)

Thanks for coming onto this journey with me, please follow me on GitHub or on Twitter for more cursed shit :)

## License
This is going under the unlicensed since I don't think I want to be the blame for wanting to do this.
