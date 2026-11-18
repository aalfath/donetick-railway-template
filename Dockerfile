# Donetick for Railway: the official image, pinned by version and digest.
# Bump the tag and digest together, and add a CHANGELOG.md entry.
FROM donetick/donetick:v0.1.86@sha256:66253a32a8e8ed8c49c49418b43abe1181db23e07defe97748d2cb7508c487cd

COPY start.sh /usr/local/bin/railway-start.sh
RUN chmod 0755 /usr/local/bin/railway-start.sh

ENV DT_ENV=selfhosted

EXPOSE 2021
CMD ["/usr/local/bin/railway-start.sh"]
