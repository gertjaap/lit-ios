package litrpcproxy

import (
	"log"
	"os"

	"github.com/mit-dci/lit/crypto/koblitz"
	"github.com/mit-dci/lit/litrpc"
)

func StartLitRpcProxy(targetNodeAdr string, localKey []byte, listenPort int) error {
	log.SetOutput(os.Stdout)
	privKey, _ := koblitz.PrivKeyFromBytes(koblitz.S256(), localKey)

	proxy, err := litrpc.NewLndcRpcWebsocketProxy(targetNodeAdr, privKey)
	if err != nil {
		return err
	}
	go proxy.Listen("localhost", uint16(listenPort))
	return nil
}

func StartUnconnectedProxy(localKey []byte, listenPort int) {
	proxy := litrpc.NewUnconnectedLndcRpcWebsocketProxy(localKey)
	go proxy.Listen("localhost", uint16(listenPort))
}
