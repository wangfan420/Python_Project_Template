FROM python:3.8

ENV POETRY_VERSION=1.1.12
ENV POETRY_HOME=/opt/poetry
ENV PATH="${POETRY_HOME}/bin:${PATH}"

RUN curl -sOSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py && \
    python get-poetry.py --yes && \
    rm get-poetry.py
RUN poetry config virtualenvs.create false

# Pass Artifactory credentials to docker build
ARG POETRY_HTTP_BASIC_ARTIFACTORY_USERNAME
ARG POETRY_HTTP_BASIC_ARTIFACTORY_PASSWORD

WORKDIR /src
COPY poetry.lock pyproject.toml ./

RUN poetry install --no-interaction

COPY . /src