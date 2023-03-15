FROM python:3.9-slim

ENV APP_HOME /app
WORKDIR $APP_HOME

COPY Pipfile ./
RUN pip install $(sed -n -e '/^\[packages\]/,/^\[/p' Pipfile |sed -e '/^\[/d' -e 's/"//g' -e 's/ = .*//' -e '/^$/d')

COPY src ./

EXPOSE 8080
ENV PORT 8080
ENTRYPOINT [ "/usr/local/bin/python3", "-m", "{{package_name}}"]
