# Uncomment the next line to define a global platform for your project
# platform :ios, '16.0'

target 'KJLeaksFinder' do
      # Comment the next line if you don't want to use dynamic frameworks
  	use_frameworks!

  	# Pods for KJLeaksFinder iOS自动检测内存泄漏工具
  	pod 'AMLeaksFinder', '2.2.8', :configurations => ['Debug']
	pod 'FBRetainCycleDetector', '0.1.4', :configurations => ['Debug']

end

post_install do |installer|
    ## Fix for XCode 12.5
    find_and_replace("Pods/FBRetainCycleDetector/FBRetainCycleDetector/Layout/Classes/FBClassStrongLayout.mm",
      "layoutCache[currentClass] = ivars;", "layoutCache[(id<NSCopying>)currentClass] = ivars;")
end

def find_and_replace(dir, findstr, replacestr)
  Dir[dir].each do |name|
      text = File.read(name)
      replace = text.gsub(findstr,replacestr)
      if text != replace
          puts "Fix: " + name
          File.open(name, "w") { |file| file.puts replace }
          STDOUT.flush
      end
  end
  Dir[dir + '*/'].each(&method(:find_and_replace))
end
