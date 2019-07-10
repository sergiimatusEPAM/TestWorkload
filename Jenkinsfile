echo "SNAPSHOT_VERSION: ${BUILD_NUMBER}"
buildNumber = "${BUILD_NUMBER}"

node("mesos-windows") {
    stage('Create work dir'){
        bat 'IF not exist C:\\Build (mkdir C:\\Build)'
    }
    stage('Checkout of git repo (ssh)') {
        bat 'git clone https://sergiimatusEPAM@github.com/alekspv/TestWorkload.git'
    }
// stage('Checkout of git repo (https)') {
//   steps {
//    git credentialsId: 'userId', url: 'https://github.com/alekspv/TestWorkload.git', branch: 'master'
//   }
//  }
    stage('Clean') {
        bat "cd TestWorkload"
        bat 'dotnet clean'
    }
    stage('Build') {
        bat 'dotnet build'
    }
    stage('Publish, pack into zip') {
        bat 'dotnet publish -o C:\\Build\\TestWorkload_app'
        bat '7z.exe a -tzip package.{buildNumber}.zip c:\\Build\\TestWorkload_app'
    }
    stage("Upload to Nexus"){
        bat "curl -v -u admin:admin123 --upload-file package.zip  http://ec2-54-226-133-173.compute-1.amazonaws.com:27092/repository/dotnet-sample/TestWorkload-{buildNumber}.zip"
    }
}