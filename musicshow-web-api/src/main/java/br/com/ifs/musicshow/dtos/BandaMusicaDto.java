package br.com.ifs.musicshow.dtos;

import br.com.ifs.musicshow.models.BandaMusicaModel;

import java.util.Date;

public record BandaMusicaDto(
        Integer id,
        Integer idBanda,
        Integer idMusica,
        Integer idRepertorio,
        Date dataInclusao,
        int ordem,
        String titulo,
        String arquivo
) {

    public static BandaMusicaDto fromModel(BandaMusicaModel bandaMusicaModel, String titulo, String arquivo) {
        return new BandaMusicaDto(
                bandaMusicaModel.getId(),
                bandaMusicaModel.getBanda().getId(),
                bandaMusicaModel.getMusica().getId(),
                bandaMusicaModel.getRepertorio().getId(),
                bandaMusicaModel.getDataInclusao(),
                bandaMusicaModel.getOrdem(),
                titulo,
                arquivo
        );
    }
}
