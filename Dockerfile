FROM --platform=arm64 ruby:3.0.2

RUN gem install solargraph

ENTRYPOINT ["solargraph"]
CMD ["socket", "--host", "0.0.0.0", "--port", "7658"]
