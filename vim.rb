dep 'vim-huge' do
  requires 'lparry:mercurial'

  met? do
    output = `vim --version`
    output.include?('Vi IMproved 7.3') and
    output.include?('Compiled by babushka') and
    output.include?('+ruby') and
    output.include?('+python')
  end

  meet do
    shell('rm -rf /tmp/vim')
    log_shell('cloning vim hg repository', 'hg clone https://vim.googlecode.com/hg/ /tmp/vim')
    cd('/tmp/vim') {|path|
      log_shell 'configuring', './configure --prefix=/usr/local/ --enable-rubyinterp --enable-gui=no --disable-gpm --enable-pythoninterp --enable-multibyte -with-features=huge --with-compiledby=babushka'

      if Babushka::Base.host.osx?
        #osx only step to make ruby stuff work properly
        log_shell 'reticulating splines', 'sed -i ".backup" -e "s/RUBY_LIBS.*/RUBY_LIBS = -framework Ruby/" -e "s/RUBY_CFLAGS.*/RUBY_CFLAGS = -I\/System\/Library\/Frameworks\/Ruby.framework\/Versions\/1.8 -I\/usr\/lib\/ruby\/1.8\/universal-darwin10.0/" -e "s/RUBY[[:space:]].*/RUBY = \/usr\/bin\/ruby/" src/auto/config.mk'
      end

      log_shell 'building', 'make'
      sudo 'make install'
    }
  end
end

