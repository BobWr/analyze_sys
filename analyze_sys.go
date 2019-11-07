package main

import "github.com/gin-gonic/gin"
import "os/exec"
// import "strconv"
import "bytes"
import "github.com/gin-contrib/cors"

var num [5] int

func main() {

    r := gin.Default()

    //cors
	r.Use(cors.New(cors.Config{
        AllowOrigins:  []string{"*"},
        AllowMethods:  []string{"PUT", "PATCH", "GET", "POST", "DELETE"},
        AllowHeaders:  []string{"content-type"},
        ExposeHeaders: []string{"X-Total-Count"},
    }))

    //run a container, uplimit is 5
    r.GET("/record", func(c *gin.Context) {

        // port,err := strconv.Atoi(c.Param("port"))
        
		// cmd := exec.Command("/bin/bash", "-c", "./docker.sh 1 " + strconv.Itoa(port))
		cmd := exec.Command("/bin/bash", "-c", "./analyze_sys_start.sh")
		
		cmd.Run()
        
        c.JSON(200, "ok")
    })

    //remove a container which port matchs the parameter [:port]
    r.GET("/data", func(c *gin.Context) {

    	// port,err := strconv.Atoi(c.Param("port"))
        var outStr string
        
		// cmd := exec.Command("/bin/bash", "-c", "./docker.sh 1 " + strconv.Itoa(port))
		cmd := exec.Command("/bin/bash", "-c", "./analyze_sys_stop.sh")
		var out bytes.Buffer
		cmd.Stdout = &out
		cmd.Run()
		outStr = out.String()
        
        c.String(200, outStr)
    })

    r.Run(":9999") // listen on 0.0.0.0:9999
}