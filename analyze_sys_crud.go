package main

import (
	"fmt"
	"github.com/gin-gonic/gin"
	"github.com/jinzhu/gorm"
	_ "github.com/jinzhu/gorm/dialects/mysql"
	"net/http"
	"github.com/gin-contrib/cors"
)

var MysqlDB *gorm.DB

type SysRecord struct {
	Id   int    `gorm:"size:11;primary_key;AUTO_INCREMENT;not null" json:"id"`
	RecordValue  string    `gorm:"type:MEDIUMTEXT;DEFAULT NULL" json:"recordValue"`
	RecordTime string `gorm:"size:255;DEFAULT NULL" json:"recordTime"`
	//gorm后添加约束，json后为对应mysql里的字段
}

func main() {
	var err error
	MysqlDB, err = gorm.Open("mysql", "root:23114mysql.@tcp(39.105.16.182:3306)/sensetime?charset=utf8")
	if err != nil {
		fmt.Println("failed to connect database:", err)
		return
	}else{
	    fmt.Println("connect database success")
	    MysqlDB.SingularTable(true)
	    MysqlDB.AutoMigrate(&SysRecord{}) //自动建表
	    fmt.Println("create table success")
	}
	defer MysqlDB.Close()

	Router()
}

func Router() {
	router := gin.Default()

	//cors
	router.Use(cors.New(cors.Config{
        AllowOrigins:  []string{"*"},
        AllowMethods:  []string{"PUT", "PATCH", "GET", "POST", "DELETE"},
        AllowHeaders:  []string{"content-type"},
        ExposeHeaders: []string{"X-Total-Count"},
    }))	

	//路径映射
	router.GET("/sysRecord", InitPage)
	router.POST("/sysRecord/create", CreateSysRecord)
	router.GET("/sysRecord/list", ListSysRecord)
	// router.PUT("/sysRecord/update", UpdateSysRecord)
	router.GET("/sysRecord/find/:id", GetSysRecord)
	// router.DELETE("/sysRecord/:id", DeleteSysRecord)
	router.Run(":10000")
}

//每个路由都对应一个具体的函数操作,从而实现了对sysRecord的增,删,改,查操作
func InitPage(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{
		"message": "pong",
	})
}
// curl -X POST -d '{"id": "1", "recordValue": "123", "recordTime":"12345678"}' http://localhost:10000/sysRecord/create
func CreateSysRecord(c *gin.Context) {
	var sysRecord SysRecord
	c.BindJSON(&sysRecord)     //使用bindJSON填充对象
	MysqlDB.Create(&sysRecord) //创建对象
	c.JSON(http.StatusOK, &sysRecord)    //返回页面
}

func ListSysRecord(c *gin.Context) {
	var sysRecord []SysRecord
	line := c.Query("line")
	MysqlDB.Limit(line).Find(&sysRecord) //限制查找前line行
	c.JSON(http.StatusOK, &sysRecord)
}

func GetSysRecord(c *gin.Context) {
	// id := c.Query("id")
	id := c.Param("id")
	var sysRecord SysRecord
	if MysqlDB == nil {
		fmt.Println(9999999999999999);
	}
	err := MysqlDB.First(&sysRecord, id).Error
	if err != nil {
		c.AbortWithStatus(404)
		fmt.Println(err.Error())
	} else {
		c.JSON(http.StatusOK, &sysRecord)
	}
}

func UpdateSysRecord(c *gin.Context) {
	var sysRecord SysRecord
	id := c.PostForm("id")                //post方法取相应字段
	err := MysqlDB.First(&sysRecord, id).Error //数据库查找主键=ID的第一行
	if err != nil {
		c.AbortWithStatus(404)
		fmt.Println(err.Error())
	} else {
		c.BindJSON(&sysRecord)
		MysqlDB.Save(&sysRecord) //提交更改
		c.JSON(http.StatusOK, &sysRecord)
	}
}

func DeleteSysRecord(c *gin.Context)  {
    id := c.Param("id")
    var sysRecord SysRecord
    MysqlDB.Where("id = ?", id).Delete(&sysRecord)
    c.JSON(http.StatusOK, gin.H{
        "data": "this has been deleted!",
    })
}