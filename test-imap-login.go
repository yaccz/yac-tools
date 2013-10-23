package main

import (
    "crypto/tls"
    "flag"
    "fmt"
    "github.com/nerdgguy/go-imap"
    "log"
)

type Config struct {
    Server struct {
        Laddr string
    }
    Auth struct {
        User       string
        Pass       string
        SkipVerify bool
    }
}

func main() {
    var Cg Config
    flag.StringVar(&Cg.Server.Laddr, "laddr", "", "")
    flag.StringVar(&Cg.Auth.User, "user", "", "")
    flag.StringVar(&Cg.Auth.Pass, "pass", "", "")
    flag.BoolVar(&Cg.Auth.SkipVerify, "skipverify", false, "")
    flag.Parse()

    tlscg := tls.Config{InsecureSkipVerify: Cg.Auth.SkipVerify}

    conn, err := tls.Dial("tcp", Cg.Server.Laddr, &tlscg)
    if err != nil {
        log.Fatalf("Conn to %s failed %s:", Cg.Server.Laddr, err)
    }

    im := imap.New(conn, conn)
    hello, err := im.Start()
    if err != nil {
        log.Fatal("Hello failed")
    }
    fmt.Printf("Server hello: %s\n", hello)

    _, caps, err := im.Auth(Cg.Auth.User, Cg.Auth.Pass)
    if err != nil {
        log.Fatalf("Auth failed: %s", err)
    }
    fmt.Println("Capabilities: ", caps)
}
