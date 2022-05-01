# Self Hosted Action Runners on Kubernetes
This repository is just a documentation of a journey on a question I had, and that question was:

> "Can I run self-hosted GitHub Action runners on Kubernetes?"

The results may shock you!

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

back to the drawing board I see!

## License
This is going under the unlicensed since I don't think I want to be the blame for wanting to do this.
