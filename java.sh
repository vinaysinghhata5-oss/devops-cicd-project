#!/bin/bash

# Usage: ./create-java-project.sh MyJavaApp com.example

PROJECT_NAME=$1
PACKAGE_NAME=$2

if [ -z "$PROJECT_NAME" ] || [ -z "$PACKAGE_NAME" ]; then
    echo "Usage: $0 <ProjectName> <PackageName>"
    exit 1
fi

# Replace dots in package name with slashes for folder structure
PACKAGE_DIR=$(echo $PACKAGE_NAME | tr '.' '/')

echo "Creating project '$PROJECT_NAME' with package '$PACKAGE_NAME'..."

# Create directories
mkdir -p $PROJECT_NAME/src/main/java/$PACKAGE_DIR
mkdir -p $PROJECT_NAME/src/test/java/$PACKAGE_DIR

# Create pom.xml
cat > $PROJECT_NAME/pom.xml <<EOL
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0
         http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>$PACKAGE_NAME</groupId>
    <artifactId>$PROJECT_NAME</artifactId>
    <version>1.0-SNAPSHOT</version>

    <properties>
        <maven.compiler.source>17</maven.compiler.source>
        <maven.compiler.target>17</maven.compiler.target>
    </properties>

    <dependencies>
        <dependency>
            <groupId>org.junit.jupiter</groupId>
            <artifactId>junit-jupiter-api</artifactId>
            <version>5.9.2</version>
            <scope>test</scope>
        </dependency>
        <dependency>
            <groupId>org.junit.jupiter</groupId>
            <artifactId>junit-jupiter-engine</artifactId>
            <version>5.9.2</version>
            <scope>test</scope>
        </dependency>
    </dependencies>

    <build>
        <plugins>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-surefire-plugin</artifactId>
                <version>3.0.0-M7</version>
            </plugin>
        </plugins>
    </build>
</project>
EOL

# Create sample App.java
cat > $PROJECT_NAME/src/main/java/$PACKAGE_DIR/App.java <<EOL
package $PACKAGE_NAME;

public class App {
    public static void main(String[] args) {
        System.out.println("Hello CI/CD!");
    }

    public static int add(int a, int b) {
        return a + b;
    }
}
EOL

# Create sample test
cat > $PROJECT_NAME/src/test/java/$PACKAGE_DIR/AppTest.java <<EOL
package $PACKAGE_NAME;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.assertEquals;

public class AppTest {
    @Test
    public void testAdd() {
        assertEquals(5, App.add(2, 3));
    }
}
EOL

echo "Java project '$PROJECT_NAME' created successfully!"

