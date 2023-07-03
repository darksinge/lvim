FROM alpine:edge

RUN apk add git neovim ripgrep alpine-sdk bash --update
RUN LV_BRANCH='release-1.2/neovim-0.8' bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/fc6873809934917b470bff1b072171879899a36b/utils/installer/install.sh)
# RUN /root/.local/bin/lvim

# RUN PATH=$PATH:/root/.local/bin

RUN echo "alias lvim='/root/.local/bin/lvim'" >> ~/.bashrc

WORKDIR /root/.config/lvim

COPY ./config.lua ./config.lua
COPY ./plugin/util.lua ./plugin/util.lua
COPY ./snippets ./snippets
COPY ./ftplugin ./ftplugin
COPY ./lua/user ./lua/user
COPY ./lsp-settings ./lsp-settings

CMD ["/bin/bash"]
