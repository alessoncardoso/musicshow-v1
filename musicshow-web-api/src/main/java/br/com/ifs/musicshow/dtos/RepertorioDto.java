package br.com.ifs.musicshow.dtos;

import br.com.ifs.musicshow.models.RepertorioModel;

import java.util.Date;

public record RepertorioDto(
        Integer id,
        Integer idBanda,
        String nome,
        int qtdMusica,
        Date dataCriacao,
        int status
) {

    public static RepertorioDto fromModel(RepertorioModel repertorioModel) {
        return new RepertorioDto(
                repertorioModel.getId(),
                repertorioModel.getBanda().getId(),
                repertorioModel.getNome(),
                repertorioModel.getQtdMusica(),
                repertorioModel.getDataCriacao(),
                repertorioModel.getStatus()
        );
    }
}
