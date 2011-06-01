dep 'mercurial' do
  met? { which 'hg' }
  meet { log_shell('Installing Mercurial...', 'easy_install Mercurial') }
end
