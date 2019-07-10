echo "SNAPSHOT_VERSION: ${BUILD_NUMBER}"
buildNumber = "${BUILD_NUMBER}"

node("mesos-windows") {
    stage('Checkout of git repo (cmd)') {
        bat 'IF not exist TestWorkload (git clone https://sergiimatusEPAM@github.com/alekspv/TestWorkload.git) else (cd TestWorkload && git pull)';
    }
// stage('Checkout of git repo (Jenkins)') {
//   steps {
//    git credentialsId: 'userId', url: 'https://github.com/alekspv/TestWorkload.git', branch: 'master'
//   }
//  }
    stage('Clean') {
        bat "cd TestWorkload && dotnet clean"
    }
    stage('Build') {
        bat 'cd TestWorkload && dotnet build'
    }
    stage('Publish, pack into zip') {
        bat 'cd TestWorkload && dotnet publish -o .\\..\\..\\target'
        bat '7z.exe a -tzip package.%BUILD_NUMBER%.zip target'
    }
    stage("Upload SNAPSHOT version to Nexus "){
        bat "curl -v -u admin:admin123 --upload-file package.%BUILD_NUMBER%.zip http://ec2-54-226-133-173.compute-1.amazonaws.com:27092/repository/dotnet-sample/0.1-SNAPSHOT/TestWorkload.zip"
    }
    stage("Upload RELEASE version to Nexus "){
        bat "curl -v -u admin:admin123 --upload-file package.%BUILD_NUMBER%.zip http://ec2-54-226-133-173.compute-1.amazonaws.com:27092/repository/dotnet-sample/RELEASE/TestWorkload-0.1.%BUILD_NUMBER%.zip"
    }
}