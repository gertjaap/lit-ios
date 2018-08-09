package litrpcproxy

import (
	"log"
	"os"

	"github.com/mit-dci/lit/btcutil/btcec"
	"github.com/mit-dci/lit/litrpc"
)

func StartLitRpcProxy(targetNodeAdr string, localKey []byte, listenPort int) error {
	log.SetOutput(os.Stdout)
	privKey, _ := btcec.PrivKeyFromBytes(btcec.S256(), localKey)

	proxy, err := litrpc.NewLndcRpcWebsocketProxy(targetNodeAdr, privKey)
	if err != nil {
		return err
	}
	go proxy.Listen("localhost", uint16(listenPort))
	return nil
}
