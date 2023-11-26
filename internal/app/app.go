package app

import (
	"fmt"
	"test_wb/config"
	"test_wb/internal/cache"
	"test_wb/internal/nats"
	"test_wb/internal/orders/generator"
	"test_wb/internal/repository"
	"test_wb/pkg/postgres"
	"time"
)

func Start(cfg *config.Config) {
	//подключаем натс стриминг
	nStart := nats.NewNats(&cfg.Nats)
	fmt.Println("Nats server is running, successfully connected")

	//подключаем бд
	postgresConnect, err := postgres.ConnectionPG(&cfg.PG)

	if err != nil {
		fmt.Printf("Error connecting to Postgresql: %v", err)
	}
	defer postgresConnect.Close()

	// соед-е бд
	repo := repository.NewRepository(postgresConnect)
	dbCreatErr := repo.CreateTable()

	if dbCreatErr != nil {
		fmt.Printf("Error creating table: %v", dbCreatErr)
	}

	// созд-е кэша
	orderCache := cache.NewCache(repo)

	//публикация(отправка заказов)в натс каждые 30 сек
	go func() {
		for {
			order := generator.GenerateOrder()
			fmt.Println("Order sent")
			err := nStart.Publish(order)

			if err != nil {
				fmt.Printf("Error at publishing: %v\n", err)
			}

			time.Sleep(30 * time.Second)
		}
	}()

	//подписка(получение сообщений от натса и сохраняет их в кэш)
	go func() {
		for {
			mes, err := nStart.Subscribe()
			fmt.Println("Order received")
			if err != nil {
				fmt.Printf("Error at subscribing: %v", err)
			}

			if err != nil {
				fmt.Printf("Error at Unmarshaling: %v", err)
			}

			orderCache.CreateCache(*mes)

			fmt.Println(cfg.Topic, ": ", mes.OrderUid)

			time.Sleep(30 * time.Second)
		}
	}()

}
