#!/bin/bash
set -euxo pipefail
source ../testFunctions.sh

pushd $1

assertFileExists ./src/main/resources/application.properties
assertFileContains ./src/main/resources/application.properties 'spring.ai.azure.openai.api-key=myapikey'
assertFileContains ./src/main/resources/application.properties 'spring.ai.azure.openai.model=gpt-4'
assertFileContains ./src/main/resources/application.properties 'spring.ai.vectorstore.pgvector.index-type=ivfflat'
assertFileContains ./src/main/resources/application.properties 'spring.ai.vectorstore.pgvector.distance-type=euclidean_distance'

assertFileExists ./pom.xml
assertPomHasProjectCoordinates ./pom.xml 'com.example' 'pgVectorAzureOpenAI'
assertPomHasDependency ./pom.xml 'org.springframework.ai' 'spring-ai-azure-openai-spring-boot-starter' '${SPRING_AI_VERSION}'
assertPomHasDependency ./pom.xml 'org.springframework.ai' 'spring-ai-tika-document-reader' '${SPRING_AI_VERSION}'
assertPomHasDependency ./pom.xml 'org.springframework.ai' 'spring-ai-pgvector-store' '${SPRING_AI_VERSION}'
assertPomHasDependency ./pom.xml 'org.springframework.boot' 'spring-boot-starter-jdbc'
assertPomHasDependency ./pom.xml 'org.postgresql' 'postgresql'
assertPomDoesntHaveDependency ./pom.xml 'org.springframework.ai' 'spring-ai-openai-spring-boot-starter' '${SPRING_AI_VERSION}'

assertFileExists ./config/workload.yaml
assertFileContains ./config/workload.yaml 'serviceClaims'
assertFileContains ./config/workload.yaml 'name: vector-store'

assertFileDoesntExist ./src/main/java/com/example/aichat/SimpleVectorStoreConfig.java

./mvnw verify -DskipTests

popd
