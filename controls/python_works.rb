title 'Tests to confirm python works as expected'

plan_name = input('plan_name', value: 'python')
plan_ident = "#{ENV['HAB_ORIGIN']}/#{plan_name}"
hab_path = input('hab_path', value: 'hab')

control 'core-plans-python' do
  impact 1.0
  title 'Ensure python works'
  desc '
  For python we check that the version is correctly returned e.g.

    $ python --version
    Python 3.8.3

  As is often customary, we also say hello to the world with python:

    $ python -c "print(\'hello world\')"
    hello world
  '
  python_pkg_ident = command("#{hab_path} pkg path #{plan_ident}")
  describe python_pkg_ident do
    its('exit_status') { should eq 0 }
    its('stdout') { should_not be_empty }
  end
  python_pkg_ident = python_pkg_ident.stdout.strip

  describe command("#{python_pkg_ident}/bin/python --version") do
    its('exit_status') { should eq 0 }
    its('stdout') { should_not be_empty }
    its('stdout') { should match /Python\s+#{python_pkg_ident.split('/')[5]}/ }
    its('stderr') { should be_empty }
  end

  describe command("#{python_pkg_ident}/bin/python -c \"print('hello world')\"") do
    its('exit_status') { should eq 0 }
    its('stdout') { should_not be_empty }
    its('stdout') { should match /hello world/ }
    its('stderr') { should be_empty }
  end
end