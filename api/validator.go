package api

import (
	"github.com/go-playground/validator/v10"
	"github.com/horiondreher/simple-bank/util"
)

var validCurrency validator.Func = func(fieldLevel validator.FieldLevel) bool {
	if currency, ok := fieldLevel.Field().Interface().(string); ok {
		if currency == "USD" || currency == "EUR" || currency == "CAD" {
			return util.IsSupportedCurrency(currency)
		}
	}

	return false
}
