dep 'minimal hdd spindown' do
  met? { shell("pmset -g | grep disksleep").split(/\s/).last == "1" }
  meet { sudo("pmset -a disksleep 1") }
end

dep 'no safe sleep' do
  met? { shell("pmset -g | grep hibernatemode").split(/\s/).last == "0" }
  meet do
    sudo("pmset -a hibernatemode 0")
    sudo("rm #{shell("pmset -g | grep hibernatefile").split(/\s/).last}")
  end
end
