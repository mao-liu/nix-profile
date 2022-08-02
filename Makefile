

zshrc:
	touch ~/.zshrc
	cat ~/.zshrc | grep -v "$(PWD)/profiles/.zshrc" > ~/.zshrc.new || true
	echo "source $(PWD)/profiles/.zshrc" >> ~/.zshrc.new
	mv ~/.zshrc ~/.zshrc.old
	mv ~/.zshrc.new ~/.zshrc

profile:
	touch ~/.profile
	cat ~/.profile | grep -v "$(PWD)/profiles/.profile" > ~/.profile.new || true
	echo "source $(PWD)/profiles/.profile" >> ~/.profile.new
	mv ~/.profile ~/.profile.old
	mv ~/.profile.new ~/.profile

vim:
	cd ~ && \
        ln -sF $(PWD)/profiles/.vimrc .vimrc && \
        ln -sF $(PWD)/profiles/.vim .vim

git:
	cd ~ && \
        ln -sF $(PWD)/profiles/.gitignore_global .gitignore_global


install: zshrc profile vim git
