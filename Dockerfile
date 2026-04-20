# Scenario: plain debian-slim base, no USER directive — the most common pattern.
# Expected MT behaviour: detect as needs_fix=True, add useradd RUN + USER 1001.
FROM python:3.12-slim

WORKDIR /app

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential \
        libpq-dev \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

ENV FLASK_APP=app
ENV FLASK_RUN_HOST=0.0.0.0

EXPOSE 5000


# Run as a non-root user for container security
RUN groupadd --system app && useradd --system --uid 1001 --gid app --create-home app
USER 1001
CMD ["flask", "run"]
