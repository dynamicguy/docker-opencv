# opencv

Latest and greatest opencv and opencv_contrib built in one container.

## how to use this image

Create a Dockerfile in your project.

```
FROM ferdous/opencv

WORKDIR /usr/src/app

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD [ "python", "./your-daemon-or-script.py" ]

```