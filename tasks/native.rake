unless IS_JRUBY
  
  # use rake-compiler for building the extension
  require 'rake/extensiontask'
  
  # build http11 C extension
  Rake::ExtensionTask.new('puma_http11', HOE.spec) do |ext|
    # define target for extension (supporting fat binaries)
    if RUBY_PLATFORM =~ /mingw|mswin/ then
      RUBY_VERSION =~ /(\d+\.\d+)/
      ext.lib_dir = "lib/#{$1}"
    elsif ENV['CROSS']
      # define cross-compilation tasks when not on Windows.
      ext.cross_compile = true
      ext.cross_platform = ['i386-mswin32', 'i386-mingw32']
    end
  
    # cleanup versioned library directory
    CLEAN.include 'lib/{1.8,1.9}'
  end
end

task :ext_clean do
  sh "rm -rf lib/puma_http11.bundle"
  sh "rm -rf lib/puma_http11.jar"
  sh "rm -rf lib/puma_http11.so"
end

# ensure things are built prior testing
task :test => [:compile]

task :clean => :ext_clean
